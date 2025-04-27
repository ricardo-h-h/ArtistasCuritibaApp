import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // A janela principal para a UI do aplicativo.
    var window: UIWindow?

    // MARK: - UIWindowSceneDelegate

    // Este método é chamado quando uma cena é adicionada ao aplicativo.
    // É o ponto principal para configurar a janela da cena e o view controller inicial.
    // Decisão de Design: Usar um UINavigationController como raiz permite fácil navegação entre a tela de lista e a tela de detalhes.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Garante que a cena é uma UIWindowScene.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Cria a janela associada a esta cena.
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        // Instancia o view controller principal (lista de obras de arte).
        let mainViewController = ViewController() // Assume que ViewController exibe a lista
        // Incorpora o view controller principal dentro de um Navigation Controller para gerenciamento da hierarquia.
        let navigationController = UINavigationController(rootViewController: mainViewController)

        // Define o Navigation Controller como o rootViewController da janela.
        window?.rootViewController = navigationController
        // Torna a janela visível.
        window?.makeKeyAndVisible()
    }

    // Chamado quando a cena foi desconectada do aplicativo (provavelmente não será reconectada).
    func sceneDidDisconnect(_ scene: UIScene) {
        // Libera recursos associados a esta cena.
    }

    // Chamado quando a cena se torna ativa e pronta para interação.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Reinicia tarefas que foram pausadas enquanto a cena estava inativa.
    }

    // Chamado quando a cena está prestes a renunciar ao estado ativo (por exemplo, devido a uma interrupção).
    func sceneWillResignActive(_ scene: UIScene) {
        // Pausa tarefas em andamento ou salva o estado.
    }

    // Chamado quando a cena está prestes a entrar em primeiro plano.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Desfaz as alterações feitas ao entrar em segundo plano.
    }

    // Chamado quando a cena entra em segundo plano (por exemplo, o usuário troca de aplicativo).
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Salva dados, libera recursos e armazena estado para restaurar mais tarde.
    }
}
