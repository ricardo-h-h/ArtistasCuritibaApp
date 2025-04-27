import UIKit

class ObraCollectionViewCell: UICollectionViewCell {

    // Identificador único para esta célula
    static let identifier = "ObraCollectionViewCell"

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // Preenche a área, mantendo a proporção (pode cortar)
        iv.clipsToBounds = true         // Corta a imagem se ela exceder os limites da UIImageView
        iv.backgroundColor = .secondarySystemBackground // Cor de fundo enquanto a imagem não carrega
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold) // Fonte um pouco maior e em negrito
        label.textColor = .label // Cor de texto padrão (adapta ao modo claro/escuro)
        label.numberOfLines = 2 // Permitir até 2 linhas para o título
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12) // Fonte menor para o artista
        label.textColor = .secondaryLabel // Cor de texto secundária
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI() // Chama a função para configurar a UI da célula
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupCellUI() {
        // Adiciona os elementos à contentView da célula
        contentView.addSubview(imageView)
        contentView.addSubview(tituloLabel)
        contentView.addSubview(artistaLabel)

        // Define a cor de fundo da célula (opcional)
        contentView.backgroundColor = .systemBackground

        // Configura as constraints para posicionar os elementos dentro da célula
        setupCellConstraints()
    }

    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            // Constraints da ImageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // Define a altura da imagem, por exemplo, 70% da altura total da célula
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),

            // Constraints do tituloLabel
            tituloLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), // 8 pontos abaixo da imagem
            tituloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8), // Margem esquerda de 8 pontos
            tituloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8), // Margem direita de 8 pontos

            // Constraints do artistaLabel
            artistaLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4), // 4 pontos abaixo do título
            artistaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            artistaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // Garante que o artistaLabel não ultrapasse a parte inferior da célula, se o título for longo
             artistaLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration

    // Método público para configurar a célula com dados de uma ObraDeArte
    func configure(with obra: ObraDeArte) {
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista

        // Carrega a imagem do Assets Catalog usando o nome fornecido
        imageView.image = UIImage(named: obra.imagemNome)
    }

    // (Opcional) Limpa a célula antes de reutilizar para evitar mostrar dados antigos
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        tituloLabel.text = nil
        artistaLabel.text = nil
    }
}
