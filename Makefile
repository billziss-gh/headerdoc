PrjDir	= $(shell pwd)
BldDir	= .build
DistDir = $(BldDir)/dist
SrcDir	= $(BldDir)/src
Status	= $(BldDir)/status
Archive = headerdoc-8.9.17

goal: $(Status) $(Status)/done

$(Status):
	mkdir -p $(Status)

$(Status)/done: $(Status)/dist
	touch $(Status)/done

$(Status)/dist: $(Status)/patch
	mkdir -p $(DistDir)
	DSTROOT=$(DistDir) make -C $(SrcDir)/$(Archive) all_internal apidoc installsub
	touch $(Status)/dist

$(Status)/patch: $(Status)/clone
	cd $(SrcDir)/$(Archive) && for f in $(PrjDir)/patches/*.patch; do patch -p1 <$$f; done
	touch $(Status)/patch

$(Status)/clone:
	mkdir -p $(SrcDir)
	cd $(SrcDir) && tar xzf $(PrjDir)/$(Archive).tar.gz
	touch $(Status)/clone

clean:
	git clean -dffx
