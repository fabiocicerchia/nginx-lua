#!/usr/bin/env python3
"""Smoke check for mirror-ghcr.py (run: python3 bin/test_mirror_ghcr.py)."""

import importlib.util
import os
import sys
import unittest
from unittest import mock

BIN = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, BIN)

_spec = importlib.util.spec_from_file_location(
    "mirror_ghcr", os.path.join(BIN, "mirror-ghcr.py")
)
mirror_ghcr = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(mirror_ghcr)

SOURCE = "fabiocicerchia/nginx-lua:1.2.3-alpine"
TARGET = "ghcr.io/fabiocicerchia/nginx-lua/nginx-lua:1.2.3-alpine"


@mock.patch.object(mirror_ghcr.common, "generate_tags", return_value=[SOURCE])
class MirrorImagesTest(unittest.TestCase):
    @mock.patch.object(mirror_ghcr.docker_ops, "run_command", return_value=[0, ""])
    def test_runs_imagetools_create(self, run, _tags):
        self.assertEqual(mirror_ghcr.mirror_images("1.2.3", "alpine", "3"), 0)
        run.assert_called_once_with(
            f"docker buildx imagetools create -t {TARGET} {SOURCE}", True
        )

    @mock.patch.object(mirror_ghcr.docker_ops, "run_command", return_value=[1, ""])
    def test_failure_propagates(self, _run, _tags):
        self.assertEqual(mirror_ghcr.mirror_images("1.2.3", "alpine", "3"), 1)


if __name__ == "__main__":
    unittest.main()
