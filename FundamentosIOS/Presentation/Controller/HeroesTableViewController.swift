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
    
// MARK: - Components
    private var activityIndicator: UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        return spinner
    }
    
// MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = activityIndicator
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
        configureNavigationBar(title: "Dragon Ball", backgroundColor: UIColor.systemIndigo)
        
        let logoutIcon = UIImage(systemName: "arrow.uturn.left.circle")
        let logoutButton = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logout))
        logoutButton.tintColor = UIColor.label
        
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func logout() {
        LocalDataModel.delete()
        let loginViewController = LoginViewController()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}

// MARK: - Networking
extension HeroesTableViewController {
    
    private func fetchHeroes() {
        NetworkModel.shared.fetchHeroes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    self?.applyInitialSnapshot()
                case .failure:
                    print("Failed to fetch heroes")
                }
            }
        }
    }
}
