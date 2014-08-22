SRC=bscan_xc7_spi.vhd

all: build/bscan_spi_kc705.bit

build/bscan_spi_kc705.prj: $(SRC)
	rm -f build/bscan_spi_kc705.prj
	for i in `echo $^`; do \
	    echo "vhdl work ../$$i" >> build/bscan_spi_kc705.prj; \
	done

build/bscan_spi_kc705.ngc: build/bscan_spi_kc705.prj
	cd build && xst -ifn ../bscan_spi_kc705.xst

build/bscan_spi_kc705.ngd: build/bscan_spi_kc705.ngc bscan_spi_kc705.ucf
	cd build && ngdbuild -uc ../bscan_spi_kc705.ucf bscan_spi_kc705.ngc

build/bscan_spi_kc705.ncd: build/bscan_spi_kc705.ngd
	cd build && map -ol high -w bscan_spi_kc705.ngd

build/bscan_spi_kc705-routed.ncd: build/bscan_spi_kc705.ncd
	cd build && par -ol high -w bscan_spi_kc705.ncd bscan_spi_kc705-routed.ncd

build/bscan_spi_kc705.bit: build/bscan_spi_kc705-routed.ncd
	cd build && bitgen -w bscan_spi_kc705-routed.ncd bscan_spi_kc705.bit

clean:
	rm -rf build/*

.PHONY: clean
