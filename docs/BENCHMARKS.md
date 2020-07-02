# Benchmarks

VM on DigitalOcean with 1vCPU and 2GB RAM.

## nginx vs nginx-lua vs openresty

![Benchmark Mean Requests per Second](http://chart.googleapis.com/chart?chco=00B140,000080,4D8D89&chd=t:256.8|257.91|259.59&chdl=nginx|nginx-lua|openresty&chdlp=bvr&chds=250,270&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Requests+per+second&chxl=0:|reqs/sec&chxr=1,250,270,5&chxt=x,y)
![Benchmark Median Response Time](http://chart.googleapis.com/chart?&chco=00B140,000080,4D8D89&chd=t:8.8|8.83|8.76&chdl=nginx|nginx-lua|openresty&chdlp=bvr&chds=8,9&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Median+Response+Time&chxl=0:|msec&chxr=1,8,9,0.2&chxt=x,y)

More details about the benchark can be found in [docs/benchmarks/different_images](docs/benchmarks/different_images).

## nginx-lua different distro

![Benchmark Mean Requests per Second](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:226.12|226.23|217.74|222.27|216.50&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=180,250&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Requests+per+second&chxl=0:|reqs/sec&chxr=1,180,250,20&chxt=x,y)
![Benchmark Median Response Time](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:9.86|9.93|10.4|10.06|10.3&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=9.5,10&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Median+Response+Time&chxl=0:|msec&chxr=1,9.5,10,0.1&chxt=x,y)

More details about the benchark can be found in [docs/benchmarks/distros](docs/benchmarks/distros).

