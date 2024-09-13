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
    private let heroes: [Hero] = [
        Hero(id: "1", description: "Saiyan Warrior", name: "Goku", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300")!, favorite: true),
        Hero(id: "2", description: "Prince of all Saiyans", name: "Vegeta", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300")!, favorite: false),
        Hero(id: "3", description: "Goku's best friend", name: "Krillin", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300")!, favorite: true),
        Hero(id: "4", description: "Protector of Earth", name: "Piccolo", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/09/piccolo.jpg?width=300")!, favorite: false),
        Hero(id: "5", description: "God of Destruction", name: "Beerus", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-super-beerus.jpg?width=300")!, favorite: true),
        Hero(id: "6", description: "The Saiyan from the future", name: "Trunks", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/07/Trunks.jpg?width=300")!, favorite: false),
        Hero(id: "7", description: "The martial arts master", name: "Roshi", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300")!, favorite: true),
        Hero(id: "8", description: "Strongest fighter in Universe 7", name: "Jiren", photo: URL(string: "https://static.wikia.nocookie.net/dragonball/images/0/03/Jiren_render.png/revision/latest?cb=20170414221953&path-prefix=es")!, favorite: false),
        Hero(id: "9", description: "Android created by Dr. Gero", name: "Android 18", photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/01/Androide-18.jpg?width=300")!, favorite: false)
    ]
    
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
        applyInitialSnapshot()
    }
    
    // MARK: - UI Configuration
    
    private func configureNavigationBar() {
        title = "Dragon Ball"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.shadowColor = UIColor.black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureTableView() {
        tableView.backgroundColor = UIColor.systemOrange
        tableView.register(UINib(nibName: HeroesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HeroesTableViewCell.identifier)
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, hero in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroesTableViewCell.identifier, for: indexPath) as? HeroesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: hero)
            cell.backgroundColor = UIColor.systemOrange
            return cell
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(heroes)
        dataSource?.apply(snapshot)
    }
}

// MARK: - TableView Delegate
extension HeroesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
