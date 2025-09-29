// graph_schema.cypher
// Manufacturing Knowledge Graph Schema and Sample Data

// Create Constraints
CREATE CONSTRAINT machine_id_unique IF NOT EXISTS FOR (m:Machine) REQUIRE m.machine_id IS UNIQUE;
CREATE CONSTRAINT operator_id_unique IF NOT EXISTS FOR (o:Operator) REQUIRE o.operator_id IS UNIQUE;
CREATE CONSTRAINT supplier_id_unique IF NOT EXISTS FOR (s:Supplier) REQUIRE s.supplier_id IS UNIQUE;
CREATE CONSTRAINT product_id_unique IF NOT EXISTS FOR (p:Product) REQUIRE p.product_id IS UNIQUE;
CREATE CONSTRAINT defect_id_unique IF NOT EXISTS FOR (d:Defect) REQUIRE d.defect_id IS UNIQUE;

// Create Machines
CREATE 
// Machines
(m1:Machine {machine_id: "M001", name: "CNC Machine 1", type: "CNC", status: "Active", installation_date: "2023-01-15"}),
(m2:Machine {machine_id: "M002", name: "Hydraulic Press 2", type: "Press", status: "Active", installation_date: "2023-02-20"}),
(m3:Machine {machine_id: "M003", name: "Injection Molder 3", type: "Molding", status: "Maintenance", installation_date: "2023-03-10"}),
(m4:Machine {machine_id: "M004", name: "Assembly Robot 4", type: "Robot", status: "Active", installation_date: "2023-04-05"}),

// Operators
(op1:Operator {operator_id: "OP001", name: "Raj Sharma", shift: "A", experience_years: 5, specialization: "CNC"}),
(op2:Operator {operator_id: "OP002", name: "Priya Patel", shift: "A", experience_years: 3, specialization: "Press"}),
(op3:Operator {operator_id: "OP003", name: "Amit Kumar", shift: "B", experience_years: 7, specialization: "Molding"}),
(op4:Operator {operator_id: "OP004", name: "Sneha Singh", shift: "B", experience_years: 2, specialization: "Assembly"}),

// Suppliers
(s1:Supplier {supplier_id: "SUP001", name: "Precision Tools Inc", category: "Tooling", reliability: "High", lead_time_days: 5}),
(s2:Supplier {supplier_id: "SUP002", name: "Steel Masters", category: "Raw Material", reliability: "Medium", lead_time_days: 7}),
(s3:Supplier {supplier_id: "SUP003", name: "Polymer Solutions", category: "Plastic", reliability: "High", lead_time_days: 3}),
(s4:Supplier {supplier_id: "SUP004", name: "Electro Components", category: "Electronics", reliability: "Low", lead_time_days: 10}),

// Products
(p1:Product {product_id: "P001", name: "Automotive Shaft", complexity: "High", target_cycle_time: 2.5}),
(p2:Product {product_id: "P002", name: "Engine Bracket", complexity: "Medium", target_cycle_time: 1.8}),
(p3:Product {product_id: "P003", name: "Plastic Housing", complexity: "Low", target_cycle_time: 0.8}),
(p4:Product {product_id: "P004", name: "Electronic Panel", complexity: "High", target_cycle_time: 3.2}),

// Defects
(d1:Defect {defect_id: "DEF001", type: "Dimensional", severity: "High", common_cause: "Tool wear"}),
(d2:Defect {defect_id: "DEF002", type: "Surface Finish", severity: "Medium", common_cause: "Lubrication issue"}),
(d3:Defect {defect_id: "DEF003", type: "Crack", severity: "Critical", common_cause: "Material defect"}),
(d4:Defect {defect_id: "DEF004", type: "Assembly Error", severity: "Medium", common_cause: "Human error"});

// Create Relationships
// Machines operated by Operators
CREATE 
(op1)-[:OPERATES {since: "2023-01-20", shift: "A"}]->(m1),
(op2)-[:OPERATES {since: "2023-02-25", shift: "A"}]->(m2),
(op3)-[:OPERATES {since: "2023-03-15", shift: "B"}]->(m3),
(op4)-[:OPERATES {since: "2023-04-10", shift: "B"}]->(m4),

// Machines produce Products
(m1)-[:PRODUCES {cycle_time: 2.6, efficiency: 95}]->(p1),
(m2)-[:PRODUCES {cycle_time: 1.9, efficiency: 92}]->(p2),
(m3)-[:PRODUCES {cycle_time: 0.85, efficiency: 88}]->(p3),
(m4)-[:PRODUCES {cycle_time: 3.3, efficiency: 90}]->(p4),

// Suppliers provide for Machines
(s1)-[:SUPPLIES {material: "Cutting Tools", cost_per_unit: 45.00}]->(m1),
(s2)-[:SUPPLIES {material: "Steel Plates", cost_per_unit: 120.00}]->(m2),
(s3)-[:SUPPLIES {material: "Plastic Pellets", cost_per_unit: 8.50}]->(m3),
(s4)-[:SUPPLIES {material: "Electronic Components", cost_per_unit: 25.00}]->(m4),

// Defects linked to Machines and Products
(m1)-[:HAS_DEFECT {defect_rate: 2.1, date: "2024-01-15"}]->(d1),
(m2)-[:HAS_DEFECT {defect_rate: 1.5, date: "2024-01-16"}]->(d2),
(m3)-[:HAS_DEFECT {defect_rate: 3.2, date: "2024-01-14"}]->(d3),
(m4)-[:HAS_DEFECT {defect_rate: 1.8, date: "2024-01-17"}]->(d4),

// Defects linked to Suppliers (material-related defects)
(d1)-[:RELATED_TO_SUPPLIER {probability: 0.6}]->(s1),
(d3)-[:RELATED_TO_SUPPLIER {probability: 0.8}]->(s3),
(d2)-[:RELATED_TO_SUPPLIER {probability: 0.4}]->(s2);

// Create additional relationships for richer queries
CREATE 
// Multiple operators can operate same machine
(op1)-[:BACKUP_OPERATOR {trained: true}]->(m2),
(op3)-[:BACKUP_OPERATOR {trained: true}]->(m1),

// Machines can have maintenance history
(m1)-[:REQUIRES_MAINTENANCE {type: "Preventive", schedule: "2024-02-01"}]->(:Maintenance {id: "MAINT001", duration_hours: 4}),
(m3)-[:REQUIRES_MAINTENANCE {type: "Corrective", schedule: "2024-01-20"}]->(:Maintenance {id: "MAINT002", duration_hours: 8});

// Return sample data count
RETURN 
"Graph created successfully!" as message,
"Nodes: " + count(*) as node_count;