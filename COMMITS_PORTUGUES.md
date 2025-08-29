# Template de Commits em Português

## 📋 Padrões de Commit Recomendados

### Tipos de Commit:
- **Funcionalidade**: Adiciona nova funcionalidade
- **Correção**: Corrige bug ou problema
- **Atualização**: Melhora funcionalidade existente
- **Tradução**: Traduz textos e comentários
- **Configuração**: Altera configurações
- **Documentação**: Atualiza documentação
- **Estilo**: Corrige formatação (sem mudança de lógica)
- **Refatoração**: Melhora código sem alterar funcionalidade
- **Performance**: Melhora performance
- **Teste**: Adiciona ou corrige testes

### Estrutura da Mensagem:
```
Tipo: Descrição breve em português (máximo 50 caracteres)

- Detalhe específico do que foi alterado
- Outro detalhe importante
- Impacto ou benefício da mudança
```

### Exemplos Práticos:

```bash
# Nova funcionalidade
git commit -m "Funcionalidade: Adiciona porta 8080 para acesso via Cloudflare

- Configura docker-compose.yml com porta 8080:80
- Atualiza security group no Terraform para liberar porta 8080
- Permite acesso direto ao website através da nova porta
- Facilita integração com CDN Cloudflare"

# Correção de bug
git commit -m "Correção: Remove arquivos .terraform do repositório

- Adiciona .terraform/ ao .gitignore
- Remove binários grandes que causavam erro no push
- Mantém apenas arquivos essenciais no versionamento"

# Atualização de configuração
git commit -m "Atualização: Melhora configuração SSL do Nginx

- Integra geração de certificados no container Nginx
- Remove container ssl-generator separado
- Simplifica arquitetura e reduz pontos de falha"

# Tradução
git commit -m "Tradução: Converte comentários para português

- Traduz user_data.sh para melhor compreensão
- Atualiza scripts de deploy com mensagens em português
- Facilita manutenção por desenvolvedores brasileiros"
```

### Comandos Git Úteis:

```bash
# Commit rápido
git add . && git commit -m "Atualização: Melhora [descreva aqui]"

# Commit com editor (para mensagens longas)
git commit

# Alterar último commit
git commit --amend -m "Nova mensagem em português"

# Ver histórico em português
git log --oneline --graph --decorate
```

### Configuração Git em Português:

```bash
# Configurar nome e email (se ainda não configurado)
git config --global user.name "Marcelo Ferreira de Menezes"
git config --global user.email "mfdemenezes@mbam.com.br"

# Configurar editor padrão
git config --global core.editor "code --wait"

# Aliases úteis em português
git config --global alias.status-br "status -s -b"
git config --global alias.historico "log --oneline --graph --decorate"
git config --global alias.ultimo "log -1 HEAD"
```
