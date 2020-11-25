make:
	mix escript.build
clean:
	rm -f neuratec ejemplo/*.out \
	test/stage_1/invalid/*.out \
	test/stage_1/valid/*.out

test: 
	cd ../

correr_pruebas: ./test_compiler.sh /path/to/your/compiler