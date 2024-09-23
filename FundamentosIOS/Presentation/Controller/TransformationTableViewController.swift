//
//  TransformationTableViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 17/9/24.
//

import UIKit

class TransformationTableViewController: UITableViewController {
    
    // MARK: - Table View DataSource
    typealias DataSource = UITableViewDiffableDataSource<Int, Transformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Transformation>
    
    // MARK: - Model
    var transformations: [Transformation] = []
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
        applyInitialSnapshot()
    }
}

// MARK: - TableView Configuration
extension TransformationTableViewController {
    
    private func configureTableView() {
        tableView.backgroundColor = UIColor.systemOrange
        // Registrar la celda adecuada para Transformation
        tableView.register(UINib(nibName: TransformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TransformationTableViewCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, transformation in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransformationTableViewCell.identifier, for: indexPath) as? TransformationTableViewCell else {
                return UITableViewCell()
            }
            // Configurar la celda con los datos de la transformación
            cell.configure(with: transformation)
            return cell
        }
    }
    
    // MARK: - Apply Initial Snapshot
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(transformations)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
    
// MARK: - TableView Delegate
extension TransformationTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedTransformation = dataSource?.itemIdentifier(for: indexPath) else { return }
        let transformationDetailsViewController = TransformationDetailsViewController()
        transformationDetailsViewController.transformation = selectedTransformation
        navigationController?.pushViewController(transformationDetailsViewController, animated: true)
    }
}

// MARK: - Navigation Bar
extension TransformationTableViewController {
    
    private func configureNavigationBar() {
        title = "Transformaciones"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.shadowColor = UIColor.black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
