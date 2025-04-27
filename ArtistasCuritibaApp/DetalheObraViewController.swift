import UIKit

class DetalheObraViewController: UIViewController {

    // MARK: - Data Property
    var obra: ObraDeArte! // Assumindo que sempre receberá uma obra

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let detalhesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descricaoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Declaração do botão de compartilhar
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.setTitle(" Compartilhar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailUI()
        configureView()
    }

    // MARK: - Setup Methods

    private func setupDetailUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Adiciona elementos à ContentView
        contentView.addSubview(imageView)
        infoStackView.addArrangedSubview(tituloLabel)
        infoStackView.addArrangedSubview(artistaLabel)
        infoStackView.addArrangedSubview(detalhesLabel)
        contentView.addSubview(infoStackView)
        contentView.addSubview(descricaoLabel)
        contentView.addSubview(shareButton) // NOVO: Adiciona o botão

        setupDetailConstraints()

        // Adiciona a ação ao botão
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }

    private func setupDetailConstraints() {
         NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descricaoLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            descricaoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descricaoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            shareButton.topAnchor.constraint(equalTo: descricaoLabel.bottomAnchor, constant: 25), // Abaixo da descrição
            shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),             // Centralizado
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30) // Define o fim da contentView
        ])
    }

    // MARK: - Configuration (sem alterações)

    private func configureView() {
        self.title = obra.titulo
        imageView.image = UIImage(named: obra.imagemNome)
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista
        detalhesLabel.text = "\(obra.estilo) - \(obra.ano)"
        descricaoLabel.text = obra.descricao
    }

    // MARK: - Actions

    // Função chamada quando o botão de compartilhar é tocado
    @objc private func shareButtonTapped() {
        print("Botão compartilhar tocado!")

        // Garante que temos os dados da obra
        guard let obra = obra else { return }

        // 1. Monta o texto que será compartilhado
        let shareText = """
        Confira esta obra de \(obra.artista): "\(obra.titulo)".
        Conheça mais artistas curitibanos!
        """

        // 2. Cria os itens para compartilhar
        let activityItems: [Any] = [shareText] // Adicione imageToShare aqui se quiser

        // 3. Cria o Activity View Controller
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // 4. (Importante para iPad) Configura onde o popover deve aparecer
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.shareButton // Ancora no botão
            popoverController.sourceRect = self.shareButton.bounds
        }

        // 5. Apresenta a tela de compartilhamento
        self.present(activityViewController, animated: true, completion: nil)
    }
}
