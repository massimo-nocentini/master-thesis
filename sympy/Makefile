
pascal-coloured:
	cp coloured.tex predefined-colour-table.tex pascal/
	cd pascal && bash pascal.sh && lualatex coloured.tex

pascal-inverted:
	cp coloured.tex predefined-colour-table.tex pascal/
	cd pascal && bash pascal-inverted.sh && lualatex coloured.tex

product-pascal-times-fibonacci:
	cp coloured.tex predefined-colour-table.tex product-pascal-times-fibonacci/
	cd product-pascal-times-fibonacci && bash pascal-times-fibonacci.sh && lualatex coloured.tex

fibonacci-coloured:
	cp coloured.tex predefined-colour-table.tex fibonacci/
	cd fibonacci && bash fibonacci.sh && lualatex coloured.tex

fibonacci-inverted:
	cp coloured.tex predefined-colour-table.tex fibonacci/
	cd fibonacci && bash fibonacci-inverted.sh && lualatex coloured.tex

product-fibonacci-times-pascal:
	cp coloured.tex predefined-colour-table.tex product-fibonacci-times-pascal/
	cd product-fibonacci-times-pascal&& bash fibonacci-times-pascal.sh && lualatex coloured.tex

# the following is a backup to run repeatedly a macro for cleaning
#catalan-coloured:
	#cp coloured.tex predefined-colour-table.tex catalan/
	#cd catalan && bash catalan.sh && lualatex coloured.tex

catalan-coloured:
	cp templates/predefined-colour-table.tex catalan/
	cd catalan && bash catalan.sh \
        && lualatex catalan-standard-colouring.tex > /dev/null \
        && echo "****standard colouring triangle pdf generated****" \
		&& lualatex catalan-repeated-differences-colouring.tex > /dev/null \
        && echo "****repeated differences colouring triangle pdf generated****"

catalan-inverted:
	cp coloured.tex predefined-colour-table.tex catalan/
	cd catalan && bash catalan-inverted.sh && lualatex coloured.tex

motzkin-coloured:
	cp coloured.tex predefined-colour-table.tex motzkin/
	cd motzkin && bash motzkin.sh && lualatex coloured.tex

motzkin-inverted:
	cp coloured.tex predefined-colour-table.tex motzkin/
	cd motzkin && bash motzkin-inverted.sh && lualatex coloured.tex

pattern-11100-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-11100/
	cd pattern-11100 && bash pattern-11100.sh && lualatex coloured.tex

pattern-101-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-101/
	cd pattern-101 && bash pattern-101.sh && lualatex coloured.tex

pattern-10101-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-10101/
	cd pattern-10101 && bash pattern-10101.sh && lualatex coloured.tex

pattern-01010-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-01010/
	cd pattern-01010 && bash pattern-01010.sh && lualatex coloured.tex

pattern-010101-coloured: 
	cp coloured.tex predefined-colour-table.tex pattern-010101/ 
	cd pattern-010101 && bash pattern-010101.sh && lualatex coloured.tex

pattern-family-10j-1-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-family-10j-1/
	cd pattern-family-10j-1 && bash pattern-family-10j-1.sh && lualatex coloured.tex

pattern-family-01j-0-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-family-01j-0/
	cd pattern-family-01j-0 && bash pattern-family-01j-0.sh && lualatex coloured.tex

pattern-family-j-j-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-family-j-j/
	cd pattern-family-j-j && bash pattern-family-j-j.sh && lualatex coloured.tex

pattern-family-1succj-0j-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-family-1succj-0j/
	cd pattern-family-1succj-0j && bash pattern-family-1succj-0j.sh && lualatex coloured.tex

pattern-family-0succj-1j-coloured:
	cp coloured.tex predefined-colour-table.tex pattern-family-0succj-1j/
	cd pattern-family-0succj-1j && bash pattern-family-0succj-1j.sh && lualatex coloured.tex
