# 🚀 GitHub Actions - Configuração

## 📋 Pré-requisitos

### 1. Configurar Secrets no GitHub

Vá em: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Adicione os seguintes secrets:

```
AWS_ACCESS_KEY_ID     = sua_access_key_id
AWS_SECRET_ACCESS_KEY = sua_secret_access_key
```

### 2. Configurar Environments (Opcional)

Para maior segurança, você pode configurar environments:
- **Settings** → **Environments** → **New environment**
- Crie: `main`, `website-main`, `containers-main`
- Configure protection rules se necessário

## 🎯 Como Usar

### Deploy Automático
- **Push para `main`**: Executa plan → apply → deploy website → update containers
- **Push para outras branches**: Apenas executa plan
- **Pull Request**: Executa plan para validação

### Deploy Manual
1. Vá em **Actions** → **Terraform Infrastructure Pipeline**
2. Clique em **Run workflow**
3. Escolha a ação:
   - `plan`: Apenas planejar
   - `apply`: Criar infraestrutura
   - `destroy`: Destruir tudo

## 📊 Monitoramento

### Logs dos Jobs
- Cada job mostra progresso detalhado
- Artifacts salvam o tfplan e outputs

### Outputs Importantes
- IP da instância EC2
- Status da infraestrutura
- Links para AWS Console

## 🔧 Diferenças do GitLab CI/CD

| Aspecto | GitLab CI/CD | GitHub Actions |
|---------|--------------|----------------|
| **Arquivo** | `.gitlab-ci.yml` | `.github/workflows/terraform.yml` |
| **Secrets** | Variables/Settings | Repository Secrets |
| **Artifacts** | Integrado | `upload-artifact` / `download-artifact` |
| **Environments** | Automático | Configuração manual |
| **Matrix** | Limitado | Nativo |

## 🚨 Comandos de Emergência

### Parar Deploy
```bash
# Cancele o workflow no GitHub Actions
```

### Destruir Infraestrutura
```bash
# Use o workflow manual com action: destroy
# OU execute localmente:
terraform destroy -auto-approve
```

### Debug Local
```bash
# Verificar estado
terraform show

# Ver outputs
terraform output

# Refresh estado
terraform refresh
```

## 📈 Next Steps

1. **Configure os secrets AWS**
2. **Faça um push para testar**
3. **Monitore o primeiro deploy**
4. **Configure domain/SSL** (opcional)

## 🔗 Links Úteis

- [AWS Console EC2](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1)
- [S3 Bucket](https://s3.console.aws.amazon.com/s3/buckets/mfdemenezes-terraform-bucket)
- [GitHub Actions](https://github.com/Mfdemenezes/eC2_site_n8n/actions)
