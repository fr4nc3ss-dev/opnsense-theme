#!/bin/sh

# ==========================================
# CONFIGURAÇÕES DO TEMA
# ==========================================
NOME_TEMA="cyberappfin"
NOVO_NOME="FW-Cyberappfin"

USUARIO_GITHUB="fr4nc3ss-dev"
REPO_GITHUB="opnsense-theme"
BRANCH="main"

URL_BASE="https://raw.githubusercontent.com/${USUARIO_GITHUB}/${REPO_GITHUB}/${BRANCH}"

echo "=========================================="
echo "  Iniciando instalacao ultra-rapida..."
echo "=========================================="

# 1. Limpar e recriar pasta do tema
rm -rf /usr/local/opnsense/www/themes/$NOME_TEMA
cp -r /usr/local/opnsense/www/themes/opnsense /usr/local/opnsense/www/themes/$NOME_TEMA

# 2. Baixar imagens
cd /usr/local/opnsense/www/themes/$NOME_TEMA/build/images/
rm -f default-logo.* icon-logo.*

fetch -q -o default-logo.png "${URL_BASE}/logo.png"
fetch -q -o icon-logo.png "${URL_BASE}/icon.png"

# 3. Sobrescrever estilo (Sem loops lentos)
CSS_DIR="/usr/local/opnsense/www/themes/$NOME_TEMA/build/css"

for f in $CSS_DIR/*.css; do
cat << 'EOF' >> "$f"

/* ==========================================
   PADRONIZAÇÃO TOTAL CINZA/PRETO (CYBERAPPFIN)
   ========================================== */

/* Linhas e bordas inferiores de títulos e widgets */
.panel-heading, .widget-header, .widget-title, .panel-title,
div[class*="panel"] h3, div[class*="panel"] h4, hr {
    border-color: #444444 !important;
    border-top-color: #444444 !important;
    border-bottom-color: #444444 !important;
}

/* Remove linhas laranja criadas por pseudo-elementos (::after / ::before) */
.panel-heading::after, .panel-heading::before,
.widget-header::after, .widget-header::before,
.widget-title::after, .widget-title::before,
.panel-title::after, .panel-title::before,
h3::after, h3::before, h4::after, h4::before {
    background-color: #444444 !important;
    border-color: #444444 !important;
}

/* Moldura dos quadros */
.panel, .panel-default, .panel-primary, div[class*="panel"], div[class*="widget"], .content-box {
    border-color: #444444 !important;
}

/* Botões */
.btn-primary, button[type="submit"] {
    background-color: #333333 !important;
    border-color: #222222 !important;
    color: #ffffff !important;
}

.btn-primary:hover, button[type="submit"]:hover {
    background-color: #444444 !important;
    border-color: #333333 !important;
}

/* Menu lateral e seleções */
.sidebar-nav li a.active, .sidebar-nav li.active > a {
    border-left: 4px solid #333333 !important;
    background-color: #e5e5e5 !important;
    color: #000000 !important;
}

/* Links e textos destacados */
a, .text-primary, .text-danger, .text-warning {
    color: #333333 !important;
}
EOF
done

# 4. Ajustar permissões
chown -R root:wheel /usr/local/opnsense/www/themes/$NOME_TEMA
chmod -R 755 /usr/local/opnsense/www/themes/$NOME_TEMA

echo "=========================================="
echo "  INSTALACAO CONCLUIDA COM SUCESSO!"
echo "=========================================="
