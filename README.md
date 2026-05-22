# LibreOffice Deploy Scripts

Scripts de instalação e configuração automatizada do LibreOffice para ambientes de laboratório/escola com perfil de usuário padronizado via rede.

---

## Estrutura do Repositório

```
.
├── script.bat       # Instalação completa: copia MSI, instala e aplica configurações
├── debug.bat        # Diagnóstico isolado: testa acesso à rede e manipulação de pastas
├── user/            # Pasta com o perfil padrão do LibreOffice a ser distribuído
└── LICENSE
```

---

## Pré-requisitos

- Windows com acesso ao compartilhamento de rede `\\TECS\Trabalhos`
- Permissão para instalar software na máquina (executar como Administrador)
- O arquivo MSI do LibreOffice disponível em `\\TECS\Trabalhos\LibreOffice_26.2.3_Win_x86-64 (1).msi`
- A pasta `\\TECS\Trabalhos\user` contendo o perfil padrão do LibreOffice

---

## Como Usar

### Instalação Completa (`script.bat`)

Executa todas as etapas em sequência:

1. Copia o instalador `.msi` da rede para `C:\Users\Aluno\Downloads`
2. Instala o LibreOffice silenciosamente (sem reinicialização)
3. Encerra processos residuais do LibreOffice
4. Verifica acesso à pasta de configurações na rede
5. Faz backup do perfil atual (`user` → `user-old`) e aplica o perfil padrão

```bat
# Executar como Administrador
script.bat
```

### Diagnóstico (`debug.bat`)

Testa apenas as etapas de manipulação de pasta e acesso à rede, **sem instalar nada**. Útil para diagnosticar problemas de permissão ou conectividade antes de rodar o script principal.

```bat
debug.bat
```

---

## Caminhos Configurados

| Variável | Valor padrão |
|---|---|
| Instalador MSI (rede) | `\\TECS\Trabalhos\LibreOffice_26.2.3_Win_x86-64 (1).msi` |
| Destino local do MSI | `C:\Users\Aluno\Downloads` |
| Perfil padrão (rede) | `\\TECS\Trabalhos\user` |
| Perfil local LO | `C:\Users\Aluno\AppData\Roaming\LibreOffice\4\user` |

Para adaptar a outro usuário ou caminho de rede, edite as variáveis no início de cada `.bat`.

---

## Tratamento de Erros

Ambos os scripts verificam cada etapa e exibem mensagens de erro descritivas. Os códigos de saída possíveis no `script.bat` são:

| Situação | Mensagem |
|---|---|
| MSI não encontrado na rede | `[ERRO] O instalador nao foi encontrado...` |
| Falha na instalação | `[ERRO] Falha na instalacao... Codigo de erro: X` |
| Rede inacessível | `[ERRO] Nao foi possivel acessar a pasta...` |
| Pasta em uso (não renomeável) | `[ERRO] Nao foi possivel renomear a pasta user...` |
| Falha na cópia do perfil | `[ERRO] Falha ao copiar a pasta de configuracoes...` |

---

## Observações

- O perfil anterior é preservado como `user-old` antes de ser substituído. A cada execução, o `user-old` anterior é removido e substituído pelo backup mais recente.
- O script de instalação usa `/passive` no `msiexec`, exibindo uma barra de progresso sem exigir interação do usuário.
- O componente de atualização online do LibreOffice (`gm_o_Onlineupdate`) é removido durante a instalação para evitar atualizações automáticas em ambientes gerenciados.
