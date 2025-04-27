import UIKit

class ViewController: UIViewController {

    // MARK: - Data
    // Array original com todas as obras
    // Array de Obras (Versão Pesquisada e com Descrições Expandidas)
        let listaDeObras: [ObraDeArte] = [
            // 1. João Turin (1878-1949) - Escultor Paranista
            ObraDeArte(titulo: "Luar do Sertão", artista: "João Turin", ano: 1947, estilo: "Escultura", imagemNome: "turin_luar",
                       descricao: "Escultura em bronze premiada no Salão Nacional de Belas Artes (1947). Turin, um dos expoentes do Paranismo, especializou-se na Bélgica e foi mestre em retratar a fauna e figuras regionais. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu turpis risus. Nunc erat lorem, lacinia id vehicula in, luctus id neque. Sed volutpat quam urna, sit amet consequat magna.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu turpis risus. Nunc erat lorem, lacinia id vehicula in, luctus id neque. Sed volutpat quam urna, sit amet consequat magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu turpis risus. Nunc erat lorem, lacinia id vehicula in, luctus id neque. Sed volutpat quam urna, sit amet consequat magna."),

            // 2. Poty Lazzarotto (1924-1998) - Muralista, Gravador, Ilustrador
            ObraDeArte(titulo: "O Largo da Ordem", artista: "Poty Lazzarotto", ano: 1993, estilo: "Mural (Azulejo)", imagemNome: "poty_largodaordem",
                       descricao: "Mural em azulejos na Tv. Nestor de Castro que evoca a memória da Curitiba antiga. Poty foi um artista versátil, conhecido por seus painéis públicos e ilustrações."),

            // 3. Alfredo Andersen (1860-1935) - Pintor Norueguês-Brasileiro
            ObraDeArte(titulo: "Porto de Paranaguá", artista: "Alfredo Andersen", ano: 1908, estilo: "Pintura", imagemNome: "andersen_porto",
                       descricao: "Pintura a óleo do norueguês radicado em Curitiba, considerado o 'Pai da Pintura Paranaense'. Sua obra combina realismo com influências impressionistas."),

            // 4. Miguel Bakun (1909-1963) - Pintor Modernista
            ObraDeArte(titulo: "Árvore Amarela", artista: "Miguel Bakun", ano: 1950, estilo: "Pintura", imagemNome: "bakun_arvore_amarela", // Ano Aprox.
                       descricao: "Obra significativa de Bakun, pioneiro da arte moderna no Paraná. Sua pintura possui acentos pós-impressionistas e expressionistas. Acervo MON."),

            // 5. Guido Viaro (1897-1971) - Pintor e Educador Ítalo-Brasileiro
            ObraDeArte(titulo: "Auto-retrato", artista: "Guido Viaro", ano: 1934, estilo: "Pintura", imagemNome: "viaro_autoretrato_1934",
                       descricao: "Autorretrato (óleo sobre tela) de Viaro, figura central na renovação da pintura moderna no Paraná e professor na Escola de Música e Belas Artes do Paraná (EMBAP)."),

            // 6. Theodoro de Bona (1904-1990) - Pintor e Professor
            ObraDeArte(titulo: "Paisagem de Morretes", artista: "Theodoro de Bona", ano: 1969, estilo: "Pintura", imagemNome: "bona_morretes",
                       descricao: "Pintura a óleo de paisagem da cidade litorânea. Nascido em Morretes, De Bona foi aluno de Andersen e também um importante professor."),

            // 7. Arthur Nísio (1906-1974) - Pintor Modernista
            ObraDeArte(titulo: "Boiadas", artista: "Arthur Nísio", ano: 1960, estilo: "Pintura", imagemNome: "nisio_boiadas", // Ano Aprox.
                       descricao: "Pintura retratando cena rural/animal. Nísio estudou na Alemanha, especializando-se em pintura de animais, e é considerado um dos modernistas paranaenses."),

            // 8. João Turin - Outra Obra
            ObraDeArte(titulo: "Marumbi", artista: "João Turin", ano: 1925, estilo: "Escultura", imagemNome: "turin_marumbi", // Ano Aprox.
                       descricao: "Escultura monumental de duas onças em luta, símbolo do Paranismo. O contorno da obra remete ao Pico Marumbi. Destaque no Memorial Paranista."),

            // 9. Poty Lazzarotto - Outra Obra
            ObraDeArte(titulo: "Monumento 1º Centenário PR", artista: "Poty Lazzarotto", ano: 1953, estilo: "Mural (Azulejo)", imagemNome: "poty_centenario",
                       descricao: "Primeiro mural de Poty em Curitiba (Praça 19 de Dezembro), feito em parceria com Erbo Stenzel e Humberto Cozzo para comemorar o centenário da emancipação política do Paraná."),

            // 10. Domício Pedroso (1930-2014) - Pintor e Gravador
            ObraDeArte(titulo: "Casarios e Favelas", artista: "Domício Pedroso", ano: 1970, estilo: "Pintura", imagemNome: "pedroso_casario", // Ano Aprox.
                       descricao: "Obra que explora a 'tessitura urbana', tema recorrente do artista. Pedroso estudou com Viaro e foi pioneiro na serigrafia artística no Paraná.")
        ]

    // Array para guardar os resultados da busca
    var filteredObras: [ObraDeArte] = []
    // Flag para saber se estamos buscando
    var isSearching: Bool = false

    // MARK: - UI Elements
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
	
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ObraCollectionViewCell.self, forCellWithReuseIdentifier: ObraCollectionViewCell.identifier)
        cv.backgroundColor = .systemBackground
        return cv
    }()

    // Declaração da Barra de Busca
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar por Título ou Artista"
        sb.searchBarStyle = .minimal
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Chama a função para configurar a UI
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Adiciona a searchBar
        view.addSubview(searchBar)
        searchBar.delegate = self // Define este ViewController como o delegate

        // Adiciona a CollectionView
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

        setupConstraints()
        self.title = "Artistas Curitibanos"

        // Inicializa a lista filtrada com todos os itens no início
        filteredObras = listaDeObras
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints para a searchBar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            // Constraints da collectionView (presa abaixo da searchBar)
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Retorna a contagem da lista apropriada (filtrada ou completa)
        return isSearching ? filteredObras.count : listaDeObras.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObraCollectionViewCell.identifier, for: indexPath) as? ObraCollectionViewCell else {
            return UICollectionViewCell()
        }
        // Pega a obra da lista apropriada (filtrada ou completa)
        let obra = isSearching ? filteredObras[indexPath.item] : listaDeObras[indexPath.item]
        cell.configure(with: obra)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

    // Animação de Highlight
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        }
    }

    // Animação de Unhighlight
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
         if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }

    // Navegação para Detalhes
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Pega a obra da lista apropriada (filtrada ou completa)
        let obraSelecionada = isSearching ? filteredObras[indexPath.item] : listaDeObras[indexPath.item]

        let detailVC = DetalheObraViewController()
        detailVC.obra = obraSelecionada
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

    // Tamanho da Célula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.bounds.width - (padding * 3)
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.7
        return CGSize(width: itemWidth, height: itemHeight)
    }

    // Espaçamento entre Linhas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Espaçamento entre Itens
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Margens da Seção
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}


// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredObras = listaDeObras
        } else {
            isSearching = true
            filteredObras = listaDeObras.filter { obra in
                let textoBuscaLower = searchText.lowercased()
                let tituloMatch = obra.titulo.lowercased().contains(textoBuscaLower)
                let artistaMatch = obra.artista.lowercased().contains(textoBuscaLower)
                return tituloMatch || artistaMatch
            }
        }
        collectionView.reloadData()
    }

    // Botão Cancelar clicado
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder() // Esconde o teclado
        filteredObras = listaDeObras
        collectionView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true) // Esconde o botão cancelar
    }

     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBar.setShowsCancelButton(true, animated: true) // Mostra o botão cancelar
     }

     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         if !searchBar.text!.isEmpty {
             isSearching = true // Garante que continue buscando se saiu sem cancelar
         }
          searchBar.setShowsCancelButton(false, animated: true)
     }
     
     // Botão de busca do teclado clicado
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder() // Esconde o teclado
     }
}
