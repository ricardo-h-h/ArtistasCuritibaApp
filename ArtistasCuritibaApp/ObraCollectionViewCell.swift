import UIKit

// Representa uma única célula dentro da collection view, exibindo uma prévia de uma obra de arte.
class ObraCollectionViewCell: UICollectionViewCell {

    // Identificador reutilizável para remover células da fila eficientemente.
    static let identifier = "ObraCollectionViewCell"

    // MARK: - Elementos de UI

    // Exibe a imagem da obra de arte.
    private let imageView: UIImageView = {
        let iv = UIImageView()
        // Redimensiona a imagem para preencher a view mantendo a proporção. Partes podem ser cortadas.
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true // Garante que a imagem não desenhe fora dos limites da image view.
        iv.backgroundColor = .secondarySystemBackground // Cor de placeholder.
        iv.translatesAutoresizingMaskIntoConstraints = false // Usar Auto Layout.
        return iv
    }()

    // Exibe o título da obra de arte.
    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold) // Fonte um pouco maior e em negrito para ênfase.
        label.textColor = .label // Adapta-se aos modos claro/escuro.
        label.numberOfLines = 2 // Permite que o título ocupe até duas linhas se necessário.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Exibe o nome do artista.
    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12) // Fonte menor para informação secundária.
        label.textColor = .secondaryLabel // Cor mais clara, adapta-se aos modos claro/escuro.
        label.numberOfLines = 1 // Espera-se que o nome do artista caiba em uma linha.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Inicializadores

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI() // Configura elementos de UI e constraints na inicialização.
    }

    // Inicializador necessário, atualmente não usado para instanciação via storyboard/nib.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado - célula configurada programaticamente.")
    }

    // MARK: - Métodos de Configuração (Setup)

    // Configura a estrutura visual da célula.
    private func setupCellUI() {
        // Adiciona elementos de UI à content view da célula.
        contentView.addSubview(imageView)
        contentView.addSubview(tituloLabel)
        contentView.addSubview(artistaLabel)

        contentView.backgroundColor = .systemBackground // Combina com o fundo do view controller.
        // Adiciona cantos arredondados para um visual mais suave (decisão de design opcional).
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true // Necessário para que o cornerRadius funcione com a imagem.

        // Define as constraints do Auto Layout.
        setupCellConstraints()
    }

    // Configura as constraints para posicionar os elementos de UI dentro da célula.
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            // Constraints da ImageView: Fixa no topo/início/fim. Altura é uma porcentagem da altura da célula.
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7), // Imagem ocupa 70% da altura da célula.

            // Constraints do tituloLabel: Posicionado abaixo da imagem com padding. Fixo nas bordas laterais com padding.
            tituloLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            tituloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tituloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            // Constraints do artistaLabel: Posicionado abaixo do título com padding. Fixo nas bordas laterais com padding.
            artistaLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            artistaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            artistaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // Garante que o label do artista não ultrapasse o padding inferior se o título for longo.
             artistaLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuração (Configuration)

    // Preenche os elementos de UI da célula com dados de um objeto ObraDeArte.
    // Este método é chamado pelo data source da collection view (ViewController).
    func configure(with obra: ObraDeArte) {
        tituloLabel.text = obra.titulo //
        artistaLabel.text = obra.artista //
        // Carrega a imagem do catálogo de assets usando o nome armazenado no objeto ObraDeArte.
        imageView.image = UIImage(named: obra.imagemNome) //
    }

    // Chamado pouco antes da célula ser reutilizada para exibir um item diferente.
    // Limpa o conteúdo existente para evitar exibir dados antigos enquanto os novos dados carregam.
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil // Limpa a imagem.
        tituloLabel.text = nil // Limpa o texto do título.
        artistaLabel.text = nil // Limpa o texto do artista.
    }
}
