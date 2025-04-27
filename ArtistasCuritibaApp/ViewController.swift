import UIKit

// Gerencia a view principal que exibe uma coleção de obras de arte e lida com a funcionalidade de busca.
class ViewController: UIViewController {

    // MARK: - Fonte de Dados (Data Source)

    // A lista completa e estática de obras de arte carregadas no aplicativo.
    // Decisão de Design: Dados codificados diretamente no fonte para simplicidade neste exemplo.
    let listaDeObras: [ObraDeArte] = [
        // ... (Dados permanecem os mesmos)
        ObraDeArte(titulo: "Luar do Sertão", artista: "João Turin", ano: 1947, estilo: "Escultura", imagemNome: "turin_luar", descricao: "Escultura em bronze premiada no Salão Nacional de Belas Artes (1947). Turin, um dos expoentes do Paranismo, especializou-se na Bélgica e foi mestre em retratar a fauna e figuras regionais. ..."),
        ObraDeArte(titulo: "O Largo da Ordem", artista: "Poty Lazzarotto", ano: 1993, estilo: "Mural (Azulejo)", imagemNome: "poty_largodaordem", descricao: "Mural em azulejos na Tv. Nestor de Castro que evoca a memória da Curitiba antiga. Poty foi um artista versátil, conhecido por seus painéis públicos e ilustrações."),
        ObraDeArte(titulo: "Porto de Paranaguá", artista: "Alfredo Andersen", ano: 1908, estilo: "Pintura", imagemNome: "andersen_porto", descricao: "Pintura a óleo do norueguês radicado em Curitiba, considerado o 'Pai da Pintura Paranaense'. Sua obra combina realismo com influências impressionistas."),
        ObraDeArte(titulo: "Árvore Amarela", artista: "Miguel Bakun", ano: 1950, estilo: "Pintura", imagemNome: "bakun_arvore_amarela", descricao: "Obra significativa de Bakun, pioneiro da arte moderna no Paraná. Sua pintura possui acentos pós-impressionistas e expressionistas. Acervo MON."),
        ObraDeArte(titulo: "Auto-retrato", artista: "Guido Viaro", ano: 1934, estilo: "Pintura", imagemNome: "viaro_autoretrato_1934", descricao: "Autorretrato (óleo sobre tela) de Viaro, figura central na renovação da pintura moderna no Paraná e professor na Escola de Música e Belas Artes do Paraná (EMBAP)."),
        ObraDeArte(titulo: "Paisagem de Morretes", artista: "Theodoro de Bona", ano: 1969, estilo: "Pintura", imagemNome: "bona_morretes", descricao: "Pintura a óleo de paisagem da cidade litorânea. Nascido em Morretes, De Bona foi aluno de Andersen e também um importante professor."),
        ObraDeArte(titulo: "Boiadas", artista: "Arthur Nísio", ano: 1960, estilo: "Pintura", imagemNome: "nisio_boiadas", descricao: "Pintura retratando cena rural/animal. Nísio estudou na Alemanha, especializando-se em pintura de animais, e é considerado um dos modernistas paranaenses."),
        ObraDeArte(titulo: "Marumbi", artista: "João Turin", ano: 1925, estilo: "Escultura", imagemNome: "turin_marumbi", descricao: "Escultura monumental de duas onças em luta, símbolo do Paranismo. O contorno da obra remete ao Pico Marumbi. Destaque no Memorial Paranista."),
        ObraDeArte(titulo: "Monumento 1º Centenário PR", artista: "Poty Lazzarotto", ano: 1953, estilo: "Mural (Azulejo)", imagemNome: "poty_centenario", descricao: "Primeiro mural de Poty em Curitiba (Praça 19 de Dezembro), feito em parceria com Erbo Stenzel e Humberto Cozzo para comemorar o centenário da emancipação política do Paraná."),
        ObraDeArte(titulo: "Casarios e Favelas", artista: "Domício Pedroso", ano: 1970, estilo: "Pintura", imagemNome: "pedroso_casario", descricao: "Obra que explora a 'tessitura urbana', tema recorrente do artista. Pedroso estudou com Viaro e foi pioneiro na serigrafia artística no Paraná.")
    ]

    // Armazena as obras atualmente exibidas, potencialmente filtradas pela barra de busca.
    var filteredObras: [ObraDeArte] = []
    // Sinalizador (flag) para rastrear se a barra de busca está ativa e o array `filteredObras` deve ser usado.
    var isSearching: Bool = false

    // MARK: - Elementos de UI

    // Define o layout para as células da collection view (aparência de grade).
    // Decisão de Design: Usando Flow Layout para um arranjo de grade padrão. Configurado programaticamente para clareza.
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Habilita rolagem vertical.
        // Tamanho da célula e espaçamento são configurados nos métodos do delegate.
        return layout
    }()

    // Exibe a grade de obras de arte. Instanciada preguiçosamente (lazy).
    // Decisão de Design: UICollectionView é adequado para exibir uma grade de itens eficientemente.
    private lazy var collectionView: UICollectionView = {
        // *** MODIFICAÇÃO: Configura o flowLayout aqui para definir espaçamentos padrão ***
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10 // Espaço horizontal entre itens na mesma linha
        layout.minimumLineSpacing = 10      // Espaço vertical entre linhas
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Margens da seção

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // Usa o layout configurado
        cv.translatesAutoresizingMaskIntoConstraints = false // Usar Auto Layout.
        // Registra a classe da célula customizada para reuso.
        cv.register(ObraCollectionViewCell.self, forCellWithReuseIdentifier: ObraCollectionViewCell.identifier)
        cv.backgroundColor = .systemBackground // Adapta-se aos modos claro/escuro.
        // O ViewController atua como data source e delegate para a collection view.
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    // Campo de entrada para filtrar obras por título ou artista.
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar por Título ou Artista"
        sb.searchBarStyle = .minimal // Estilo visual menos intrusivo.
        sb.translatesAutoresizingMaskIntoConstraints = false
        // O delegate será definido em setupUI()
        return sb
    }()

    // MARK: - Métodos do Ciclo de Vida (Lifecycle)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Inicializa a lista filtrada com todas as obras no início.
        filteredObras = listaDeObras
        setupUI() // Configura a hierarquia da view e as constraints.
    }

    // *** NOVO: Recalcula o layout quando as bounds da view mudam (ex: rotação) ***
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Invalida o layout para que sizeForItemAt seja chamado novamente
        collectionView.collectionViewLayout.invalidateLayout()
    }


    // MARK: - Métodos de Configuração (Setup)

    // Configura a estrutura geral da UI do view controller.
    private func setupUI() {
        view.backgroundColor = .systemBackground
        self.title = "Artistas Curitibanos" // Define o título exibido na barra de navegação.

        // Adiciona elementos de UI à hierarquia da view.
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        // Define este ViewController como o delegate da searchBar para lidar com a entrada do usuário.
        searchBar.delegate = self

        // Estabelece as constraints do Auto Layout.
        setupConstraints()
    }

    // Define as constraints do Auto Layout para os elementos de UI.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints da searchBar: Fixa no topo da área segura e nas bordas laterais.
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            // Constraints da collectionView: Posiciona abaixo da searchBar e preenche o espaço restante.
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
// Fornece dados (células) para a collection view.
extension ViewController: UICollectionViewDataSource {

    // Retorna o número de itens a serem exibidos. Usa a lista filtrada se estiver buscando, caso contrário, a lista completa.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredObras.count : listaDeObras.count
    }

    // Cria e configura uma célula para um item específico.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Remove uma célula reutilizável da fila para eficiência. Deve fazer o cast para o tipo de célula customizada.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObraCollectionViewCell.identifier, for: indexPath) as? ObraCollectionViewCell else {
            fatalError("Falha ao remover ObraCollectionViewCell da fila.") // Não deve acontecer se registrada corretamente.
        }
        // Determina qual fonte de dados de obra usar com base no status da busca.
        let obra = isSearching ? filteredObras[indexPath.item] : listaDeObras[indexPath.item]
        // Configura a célula com os dados específicos da obra.
        cell.configure(with: obra)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
// Lida com interações do usuário com a collection view (seleção, destaque).
extension ViewController: UICollectionViewDelegate {

    // Fornece feedback visual quando uma célula é tocada (touch down).
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            // Anima um leve efeito de redução de escala.
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        }
    }

    // Reverte o efeito de destaque quando o toque é liberado.
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
         if let cell = collectionView.cellForItem(at: indexPath) {
            // Anima de volta ao tamanho original.
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }

    // Lida com a seleção de uma célula de obra de arte.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Determina qual obra foi selecionada com base no status da busca.
        let obraSelecionada = isSearching ? filteredObras[indexPath.item] : listaDeObras[indexPath.item]

        // Cria uma instância do view controller de detalhes.
        let detailVC = DetalheObraViewController()
        // Passa os dados da obra selecionada para o view controller de detalhes.
        detailVC.obra = obraSelecionada
        // Empurra (push) o view controller de detalhes na pilha de navegação.
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
// Controla o layout (tamanho, espaçamento) das células da collection view.
extension ViewController: UICollectionViewDelegateFlowLayout {

    // Define o tamanho para cada célula na collection view.
    // *** MODIFICAÇÃO: Calcula dinamicamente o número de colunas e o tamanho do item ***
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Pega o flow layout atual para acessar os espaçamentos definidos
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero // Retorna tamanho zero se não for um flow layout
        }

        // Largura desejada/mínima para uma célula. Ajuste este valor conforme necessário.
        let targetCellWidth: CGFloat = 160 // Exemplo: 160 pontos

        // Calcula a largura total disponível para as células, subtraindo as margens laterais da seção.
        let availableWidth = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right

        // Calcula quantas colunas cabem, considerando a largura alvo e o espaçamento mínimo entre itens.
        // Começa assumindo 1 coluna e adiciona colunas enquanto couberem.
        var numberOfColumns = 1
        while true {
            let nextColumnCount = numberOfColumns + 1
            // Calcula a largura total necessária para 'nextColumnCount' colunas
            let totalWidthForNextCount = (targetCellWidth * CGFloat(nextColumnCount)) + (flowLayout.minimumInteritemSpacing * CGFloat(nextColumnCount - 1))
            if totalWidthForNextCount <= availableWidth {
                numberOfColumns = nextColumnCount // Se couber, incrementa o número de colunas
            } else {
                break // Se não couber mais, para o loop
            }
        }

        // Calcula o espaço total de padding horizontal que será usado entre as colunas.
        let totalHorizontalPadding = flowLayout.minimumInteritemSpacing * CGFloat(numberOfColumns - 1)

        // Calcula a largura final de cada item dividindo o espaço restante pelo número de colunas.
        let itemWidth = (availableWidth - totalHorizontalPadding) / CGFloat(numberOfColumns)

        // Garante que a largura do item não seja negativa ou muito pequena (importante em edge cases).
        let finalItemWidth = max(0, itemWidth.rounded(.down)) // Arredonda para baixo

        // Calcula a altura baseada na largura para manter uma proporção (ajuste o multiplicador como desejar).
        let itemHeight = finalItemWidth * 1.7 // Mesma proporção de antes

        return CGSize(width: finalItemWidth, height: itemHeight)
    }
}


// MARK: - UISearchBarDelegate
// Lida com eventos da search bar (mudanças de texto, cliques de botão).
extension ViewController: UISearchBarDelegate {

    // Chamado sempre que o texto na search bar muda.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Se o texto de busca for limpo, para de buscar e mostra todas as obras.
            isSearching = false
            filteredObras = listaDeObras
        } else {
            // Se houver texto de busca, ativa o modo de busca.
            isSearching = true
            // Filtra a lista principal com base no texto de busca (sem diferenciar maiúsculas/minúsculas).
            // Decisão de Design: Filtragem simples verificando se o título ou artista contém o texto de busca.
            filteredObras = listaDeObras.filter { obra in
                let textoBuscaLower = searchText.lowercased()
                let tituloMatch = obra.titulo.lowercased().contains(textoBuscaLower)
                let artistaMatch = obra.artista.lowercased().contains(textoBuscaLower)
                // Retorna true se o título ou o artista corresponderem.
                return tituloMatch || artistaMatch
            }
        }
        // Atualiza a collection view para exibir a lista atualizada (filtrada ou completa).
        collectionView.reloadData()
    }

    // Chamado quando o botão 'Cancelar' na search bar é tocado.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Para de buscar, limpa o texto da search bar e dispensa o teclado.
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder() // Esconde o teclado.
        filteredObras = listaDeObras // Reseta para a lista completa.
        collectionView.reloadData() // Atualiza a exibição.
        searchBar.setShowsCancelButton(false, animated: true) // Esconde o botão cancelar.
    }

     // Chamado quando a search bar se torna o primeiro respondente (é tocada).
     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBar.setShowsCancelButton(true, animated: true) // Mostra o botão cancelar quando a edição começa.
     }

     // Chamado quando a search bar renuncia ao status de primeiro respondente.
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         // Mantém a busca ativa se o texto permanecer após o fim da edição (ex: tocou fora).
         if let text = searchBar.text, !text.isEmpty {
             isSearching = true
         }
         // Esconde o botão cancelar a menos que a edição recomece imediatamente.
          searchBar.setShowsCancelButton(false, animated: true)
     }

     // Chamado quando o botão 'Buscar' no teclado é tocado.
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder() // Dispensa o teclado.
     }
}
