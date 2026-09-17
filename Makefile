# Makefile de nível superior: compila o simulador do Mancha completo e,
# em seguida, o compilador C (compilador_c/ depende do montador de
# simulador_completo/bin/ para montar seus exemplos em .mob).

.PHONY: all simulador_completo compilador_c T1 clean clean-simulador_completo clean-compilador_c clean-T1

# Adiciona T1 ao alvo principal
all: simulador_completo compilador_c T1

# compilador_c usa ../simulador_completo/bin/montador, então precisa rodar depois
simulador_completo:
	$(MAKE) -C simulador_completo all

compilador_c: simulador_completo
	$(MAKE) -C compilador_c all

# T1 precisa do compilador mcc e das bibliotecas de runtime prontas, dependendo de compilador_c
T1: compilador_c
	$(MAKE) -C T1 all

# Adiciona a limpeza do T1 ao clean geral
clean: clean-compilador_c clean-simulador_completo clean-T1

clean-simulador_completo:
	$(MAKE) -C simulador_completo clean

clean-compilador_c:
	$(MAKE) -C compilador_c clean

clean-T1:
	$(MAKE) -C T1 clean
