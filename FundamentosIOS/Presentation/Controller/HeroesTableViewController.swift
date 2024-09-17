//
//  HeroesTableViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//

import UIKit

final class HeroesTableViewController: UITableViewController {
    
    // MARK: - Table View DataSource
    typealias DataSource = UITableViewDiffableDataSource<Int, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hero>
    
    // MARK: - Model
    private var heroes: [Hero] = []
    private var dataSource: DataSource?
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureDataSource()
        fetchHeroes()
    }
}

// MARK: - TableView Configuration
extension HeroesTableViewController {
    
    private func configureTableView() {
        tableView.backgroundColor = UIColor.systemOrange
        tableView.register(UINib(nibName: HeroesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HeroesTableViewCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, hero in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroesTableViewCell.identifier, for: indexPath) as? HeroesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: hero)
            cell.backgroundColor = UIColor.systemOrange
            return cell
        }
    }
    
    // MARK: - Apply Initial Snapshot
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(heroes)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
    
// MARK: - TableView Delegate
extension HeroesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedHero = dataSource?.itemIdentifier(for: indexPath) else { return }
        let detailViewController = HeroDetailsViewController()
        detailViewController.hero = selectedHero
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - Navigation Bar
extension HeroesTableViewController {
    
    private func configureNavigationBar() {
        title = "Dragon Ball"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.shadowColor = UIColor.black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let logoutIcon = UIImage(systemName: "arrow.uturn.left.circle")
        let logoutButton = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logout))
        logoutButton.tintColor = UIColor.label
        
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        let loginViewController = LoginViewController()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}

// MARK: - Networking
extension HeroesTableViewController {
    
    private func fetchHeroes() {
        guard let request = createHeroesRequest() else {
            print("No se pudo crear el request")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error en la petición: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos")
                return
            }
            
            do {
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                DispatchQueue.main.async {
                    self.heroes = heroes
                    self.applyInitialSnapshot()
                }
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Request
    private func createHeroesRequest() -> URLRequest? {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token no disponible")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["name": ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return request
    }
}
