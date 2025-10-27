//
//  ShipViewController.swift
//  MobileTest
//
//  Created by xieshengyang on 2025/10/26.
//

import UIKit
import Combine

class ShipViewController: UIViewController {

    private let viewModel: ShipViewModel
    
    // 列表
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ShipViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShipCell")
        view.addSubview(tableView)
    }
    
    private func bindViewModel() {
        viewModel.$shipDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ShipViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.shipDetail?.segments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShipCell", for: indexPath)
        
        if indexPath.section == 0 {
            if viewModel.isLoading {
                cell.textLabel?.text = "刷新中"
            } else {
                if let _ = viewModel.error {
                    cell.textLabel?.text = "请求错误"
                } else {
                    cell.textLabel?.text = "请求数据（缓存超过5秒强制请求服务器）"
                }
            }
        } else {
            if let segment = viewModel.shipDetail?.segments[indexPath.row] {
                cell.textLabel?.text = segment.originAndDestinationPair.destinationCity
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            viewModel.loadData()
        }
    }
}

