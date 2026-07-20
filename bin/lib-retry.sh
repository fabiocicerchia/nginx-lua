# Shared by bin/sign-image.sh and bin/sign-manifest.sh.
# Retry a command with exponential backoff on Docker rate-limit errors (HTTP 429 / TOOMANYREQUESTS).
retry_on_rate_limit() {
    local max_retries="${SIGN_MAX_RETRIES:-4}"
    local delay=2
    local attempt=0
    local output_file
    output_file=$(mktemp /tmp/retry-output-XXXXXX)
    while true; do
        local rc=0
        "$@" > "$output_file" 2>&1 || rc=$?
        if [ $rc -eq 0 ]; then
            cat "$output_file"
            rm -f "$output_file"
            return 0
        fi
        if grep -qi "TOOMANYREQUESTS\|rate limit\|429" "$output_file" && [ $attempt -lt "$max_retries" ]; then
            attempt=$((attempt + 1))
            echo "Rate limited – retrying in ${delay}s (attempt ${attempt}/${max_retries})…"
            sleep $delay
            delay=$((delay * 2))
        else
            cat "$output_file"
            rm -f "$output_file"
            return $rc
        fi
    done
}
