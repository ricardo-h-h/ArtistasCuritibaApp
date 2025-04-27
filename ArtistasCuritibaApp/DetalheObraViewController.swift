import UIKit

// Exibe as informações detalhadas de uma única obra de arte selecionada.
class DetalheObraViewController: UIViewController {

    // MARK: - Propriedade de Dados
    // Armazena os dados da obra de arte passados da tela anterior (ViewController).
    // Decisão de Design: Usar um optional implicitamente desempacotado (!) assume que esta propriedade
    // *sempre* será definida antes da view carregar. Uma abordagem mais segura poderia envolver
    // um inicializador falível ou verificar por nil no viewDidLoad.
    var obra: ObraDeArte!

    // MARK: - Elementos de UI

    // Permite a rolagem para conteúdo que pode exceder a altura da tela.
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false // Usar Auto Layout.
        return sv
    }()

    // View contêiner colocada dentro da scroll view para conter todos os elementos de conteúdo.
    // As constraints desta view determinam a área rolável.
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false // Usar Auto Layout.
        return view
    }()

    // Exibe a imagem da obra de arte.
    private let imageView: UIImageView = {
        let iv = UIImageView()
        // Redimensiona a imagem para caber dentro dos limites da view mantendo a proporção.
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground // Cor de placeholder.
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Exibe o título da obra de arte.
    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold) // Fonte grande e em negrito para o título.
        label.textColor = .label // Adapta-se aos modos claro/escuro.
        label.numberOfLines = 0 // Permite múltiplas linhas.
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Exibe o nome do artista.
    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium) // Fonte de peso médio.
        label.textColor = .secondaryLabel // Cor mais clara.
        label.numberOfLines = 0 // Permite múltiplas linhas.
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Exibe detalhes secundários como estilo e ano.
    private let detalhesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Exibe a descrição completa da obra de arte.
    private let descricaoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0 // Permite o texto completo da descrição.
        label.textAlignment = .justified // Texto justificado para melhor legibilidade de parágrafos longos.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Agrupa os labels de título, artista e detalhes verticalmente.
    // Decisão de Design: UIStackView simplifica o gerenciamento do layout para estes labels relacionados.
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical // Organiza os elementos verticalmente.
        stackView.spacing = 10 // Espaço entre os labels.
        stackView.alignment = .center // Centraliza os labels horizontalmente dentro da stack.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Botão para acionar a folha de compartilhamento padrão do iOS.
    private let shareButton: UIButton = {
        let button = UIButton(type: .system) // Estilo de botão do sistema.
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal) // Ícone padrão de compartilhamento.
        button.setTitle(" Compartilhar", for: .normal) // Texto ao lado do ícone.
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .systemBlue // Cor azul padrão para itens acionáveis.
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - Métodos do Ciclo de Vida (Lifecycle)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Verifica se a propriedade 'obra' foi definida corretamente.
        guard obra != nil else {
            // Lida com o erro: talvez dispensar o view controller ou mostrar um alerta.
            print("Erro: Dados de ObraDeArte ausentes.")
            // Dependendo do comportamento desejado, você pode remover o view controller da pilha:
            // navigationController?.popViewController(animated: false)
            return
        }
        setupDetailUI() // Configura a hierarquia da view e as constraints.
        configureView() // Preenche os elementos de UI com os dados da obra.
    }

    // MARK: - Métodos de Configuração (Setup)

    // Configura a estrutura geral da UI da tela de detalhes.
    private func setupDetailUI() {
        view.backgroundColor = .systemBackground
        // Adiciona a scroll view à view principal.
        view.addSubview(scrollView)
        // Adiciona a content view dentro da scroll view.
        scrollView.addSubview(contentView)

        // Adiciona elementos de UI individuais à content view.
        contentView.addSubview(imageView)
        // Adiciona os labels à stack view primeiro.
        infoStackView.addArrangedSubview(tituloLabel)
        infoStackView.addArrangedSubview(artistaLabel)
        infoStackView.addArrangedSubview(detalhesLabel)
        // Adiciona a stack view e outros elementos à content view.
        contentView.addSubview(infoStackView)
        contentView.addSubview(descricaoLabel)
        contentView.addSubview(shareButton)

        // Configura as constraints do Auto Layout para todos os elementos.
        setupDetailConstraints()

        // Conecta o evento de toque do botão de compartilhar ao método de ação de compartilhar.
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }

    // Define as constraints do Auto Layout para os elementos de UI.
    private func setupDetailConstraints() {
         // Constraints da ScrollView: Fixa em todas as bordas da área segura.
         NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Constraints da ContentView: Fixa em todas as bordas da scroll view.
        // Crucialmente, também restringe sua largura à largura da scroll view
        // e define uma constraint de altura (pode ser flexível, ex: >= altura da scroll view ou determinada pelo conteúdo).
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        // Diminuir a prioridade permite que a content view cresça mais alta que a scroll view com base em seu conteúdo.
        heightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor), // Usar contentLayoutGuide
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor), // Usar frameLayoutGuide para largura
            heightConstraint // Manter a constraint de altura flexível
        ])

        // Constraints para elementos dentro da ContentView:
        NSLayoutConstraint.activate([
            // ImageView: Padding superior, padding lateral, altura fixa relativa à altura da view.
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            // Decisão de Design: Altura da imagem é 40% da altura da view principal. Poderia também usar um valor fixo ou aspect ratio.
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            // InfoStackView: Abaixo da imagem, padding lateral.
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // DescricaoLabel: Abaixo da stack view, padding lateral.
            descricaoLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            descricaoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descricaoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // ShareButton: Abaixo da descrição, centralizado horizontalmente, padding inferior.
            // Esta constraint inferior é crucial para definir a altura do conteúdo rolável.
            shareButton.topAnchor.constraint(equalTo: descricaoLabel.bottomAnchor, constant: 25),
            shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    // MARK: - Configuração (Configuration)

    // Preenche os elementos de UI com dados da propriedade `obra`.
    private func configureView() {
        // Define o título da barra de navegação.
        self.title = obra.titulo //
        // Carrega e exibe a imagem.
        imageView.image = UIImage(named: obra.imagemNome) //
        // Define o texto para os labels.
        tituloLabel.text = obra.titulo //
        artistaLabel.text = obra.artista //
        detalhesLabel.text = "\(obra.estilo) - \(obra.ano)" //
        descricaoLabel.text = obra.descricao //
    }

    // MARK: - Ações (Actions)

    // Chamado quando o shareButton é tocado.
    @objc private func shareButtonTapped() {
        print("Botão compartilhar tocado!") // Log de depuração

        // Garante que os dados da `obra` estão disponíveis (verificação redundante se o guard no viewDidLoad existir, mas segura).
        guard let obra = obra else { return } //

        // 1. Constrói o conteúdo de texto a ser compartilhado.
        // Decisão de Design: Formato de texto simples incluindo artista e título.
        let shareText = """
        Confira esta obra de \(obra.artista): "\(obra.titulo)".
        Conheça mais artistas curitibanos!
        """ //

        // (Opcional) Incluir a imagem no compartilhamento:
        // let imageToShare = imageView.image

        // 2. Cria o array de itens a serem compartilhados. Atualmente apenas texto.
        // Se compartilhar imagem: let activityItems: [Any] = [shareText, imageToShare].compactMap { $0 }
        let activityItems: [Any] = [shareText]

        // 3. Inicializa o activity view controller padrão do iOS (folha de compartilhamento).
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // 4. Configura a apresentação para iPad.
        // A folha de compartilhamento precisa de um ponto de âncora (source view e rect) no iPad.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.shareButton // Ancora no próprio botão de compartilhar.
            popoverController.sourceRect = self.shareButton.bounds
            // Opcional: Impede o descarte tocando fora do popover
            // popoverController.permittedArrowDirections = [] // Ou especifica direções
        }

        // 5. Apresenta a folha de compartilhamento modalmente.
        self.present(activityViewController, animated: true, completion: nil)
    }
}
