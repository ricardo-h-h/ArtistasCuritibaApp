//
//  AppDelegate.swift
//  ArtistasCuritibaApp
//
//  Created by user277150 on 4/26/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate

    // Este método é chamado após o aplicativo terminar de iniciar.
    // É o ponto de entrada tradicional para configuração em nível de aplicativo antes que a UI seja exibida.
    // No iOS moderno (13+), a maior parte da responsabilidade pela configuração da UI foi movida para o SceneDelegate.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Atualmente, nenhuma customização específica é necessária aqui após o lançamento.
        return true
    }

    // MARK: - UISceneSession Lifecycle

    // Chamado quando uma nova sessão de cena está sendo criada.
    // Este método retorna a configuração para a nova cena.
    // A "Default Configuration" especificada no Info.plist é tipicamente usada aqui.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Chamado quando o usuário descarta uma sessão de cena (por exemplo, deslizando-a no seletor de aplicativos).
    // Use este método para limpar recursos associados à(s) cena(s) descartada(s).
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Libere quaisquer recursos que eram específicos das cenas descartadas, pois elas não retornarão.
    }
}
