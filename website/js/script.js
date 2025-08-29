// Script para página bio
document.addEventListener('DOMContentLoaded', function() {
    
    // Atualizar data de última modificação
    const lastUpdate = document.getElementById('last-update');
    if (lastUpdate) {
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        lastUpdate.textContent = now.toLocaleDateString('pt-BR', options);
    }

    // Smooth scroll para links internos
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Animação de entrada dos cards
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observar todos os cards e seções
    document.querySelectorAll('.skill-card, .project-card, section').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Efeito de digitação no título (opcional)
    const title = document.querySelector('.profile-header h1');
    if (title) {
        const text = title.textContent;
        title.textContent = '';
        title.style.borderRight = '2px solid #667eea';
        
        let i = 0;
        const typeWriter = () => {
            if (i < text.length) {
                title.textContent += text.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            } else {
                // Remove o cursor após terminar
                setTimeout(() => {
                    title.style.borderRight = 'none';
                }, 1000);
            }
        };
        
        // Iniciar efeito após um delay
        setTimeout(typeWriter, 500);
    }

    // Tracking de clicks nos links sociais (para analytics se necessário)
    document.querySelectorAll('.social-links a, .contact-item').forEach(link => {
        link.addEventListener('click', function() {
            console.log(`Click no link: ${this.href}`);
            // Aqui você pode adicionar código de analytics
        });
    });

    // Easter egg - Konami Code
    let konamiCode = [];
    const konami = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]; // ↑↑↓↓←→←→BA
    
    document.addEventListener('keydown', function(e) {
        konamiCode.push(e.keyCode);
        if (konamiCode.length > konami.length) {
            konamiCode.shift();
        }
        
        if (konamiCode.length === konami.length && 
            konamiCode.every((code, index) => code === konami[index])) {
            // Easter egg ativado!
            document.body.style.transform = 'rotate(360deg)';
            document.body.style.transition = 'transform 2s ease';
            
            setTimeout(() => {
                document.body.style.transform = '';
                alert('🎉 Easter egg encontrado! Você é um verdadeiro dev!');
            }, 2000);
            
            konamiCode = [];
        }
    });

    // Preloader simples
    window.addEventListener('load', function() {
        document.body.classList.add('loaded');
    });
    
});

// Função para atualizar conteúdo via API (futuro)
async function updateContent() {
    try {
        // Futuramente pode buscar dados de uma API
        console.log('Verificando atualizações...');
        // const response = await fetch('/api/content');
        // const data = await response.json();
        // Atualizar DOM conforme necessário
    } catch (error) {
        console.error('Erro ao atualizar conteúdo:', error);
    }
}

// Verificar atualizações a cada 5 minutos (se necessário)
// setInterval(updateContent, 5 * 60 * 1000);
