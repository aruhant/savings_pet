import 'dart:convert';
import 'package:goals/secrets.dart';
import 'package:http/http.dart' as http;

// Models
class TeamRegistration {
  final String teamName;
  final String contactEmail;

  TeamRegistration({required this.teamName, required this.contactEmail});

  Map<String, dynamic> toJson() => {
    'team_name': teamName,
    'contact_email': contactEmail,
  };
}

class TeamAuthResponse {
  final String teamId;
  final String jwtToken;
  final String expiresAt;

  TeamAuthResponse({
    required this.teamId,
    required this.jwtToken,
    required this.expiresAt,
  });

  factory TeamAuthResponse.fromJson(Map<String, dynamic> json) =>
      TeamAuthResponse(
        teamId: json['teamId'],
        jwtToken: json['jwtToken'],
        expiresAt: json['expiresAt'],
      );
}

class ClientCreate {
  final String name;
  final String email;
  final double cash;
  final List<dynamic>? portfolios;

  ClientCreate({
    required this.name,
    required this.email,
    required this.cash,
    this.portfolios,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'cash': cash,
    'portfolios': portfolios ?? [],
  };
}

class ClientUpdate {
  final String? name;
  final String? email;

  ClientUpdate({this.name, this.email});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
  };
}

class Client {
  final String id;
  final String name;
  final String email;
  final String teamName;
  final List<Portfolio> portfolios;
  final double cash;
  final String createdAt;
  final String updatedAt;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.teamName,
    required this.portfolios,
    required this.cash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    teamName: json['team_name'],
    portfolios: (json['portfolios'] as List)
        .map((e) => Portfolio.fromJson(e))
        .toList(),
    cash: (json['cash'] as num).toDouble(),
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}

class PortfolioCreate {
  final String type;
  final double initialAmount;

  PortfolioCreate({required this.type, required this.initialAmount});

  Map<String, dynamic> toJson() => {
    'type': type,
    'initialAmount': initialAmount,
  };
}

class Portfolio {
  final String id;
  final String clientId;
  final String teamName;
  final String type;
  final String createdAt;
  final double investedAmount;
  final double currentValue;
  final int totalMonthsSimulated;
  final List<Transaction> transactions;
  final List<GrowthDataPoint> growthTrend;

  Portfolio({
    required this.id,
    required this.clientId,
    required this.teamName,
    required this.type,
    required this.createdAt,
    required this.investedAmount,
    required this.currentValue,
    required this.totalMonthsSimulated,
    required this.transactions,
    required this.growthTrend,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
    id: json['id'],
    clientId: json['client_id'],
    teamName: json['team_name'],
    type: json['type'],
    createdAt: json['created_at'],
    investedAmount: (json['invested_amount'] as num).toDouble(),
    currentValue: (json['current_value'] as num).toDouble(),
    totalMonthsSimulated: json['total_months_simulated'],
    transactions: (json['transactions'] as List)
        .map((e) => Transaction.fromJson(e))
        .toList(),
    growthTrend: (json['growth_trend'] as List)
        .map((e) => GrowthDataPoint.fromJson(e))
        .toList(),
  );
}

class Transaction {
  final String id;
  final String date;
  final String type;
  final double amount;
  final double balanceAfter;

  Transaction({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.balanceAfter,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    date: json['date'],
    type: json['type'],
    amount: (json['amount'] as num).toDouble(),
    balanceAfter: (json['balance_after'] as num).toDouble(),
  );
}

class GrowthDataPoint {
  final String date;
  final double value;

  GrowthDataPoint({required this.date, required this.value});

  factory GrowthDataPoint.fromJson(Map<String, dynamic> json) =>
      GrowthDataPoint(
        date: json['date'],
        value: (json['value'] as num).toDouble(),
      );
}

class SimulationRequest {
  final int months;

  SimulationRequest({required this.months});

  Map<String, dynamic> toJson() => {'months': months};
}

class SimulationResult {
  final String portfolioId;
  final String strategy;
  final int monthsSimulated;
  final int daysSimulated;
  final double initialValue;
  final double projectedValue;
  final int totalGrowthPoints;
  final String simulationId;
  final List<GrowthDataPoint> growthTrend;

  SimulationResult({
    required this.portfolioId,
    required this.strategy,
    required this.monthsSimulated,
    required this.daysSimulated,
    required this.initialValue,
    required this.projectedValue,
    required this.totalGrowthPoints,
    required this.simulationId,
    required this.growthTrend,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) =>
      SimulationResult(
        portfolioId: json['portfolioId'],
        strategy: json['strategy'],
        monthsSimulated: json['monthsSimulated'],
        daysSimulated: json['daysSimulated'],
        initialValue: json['initialValue'],
        projectedValue: json['projectedValue'],
        totalGrowthPoints: json['totalGrowthPoints'],
        simulationId: json['simulationId'],
        growthTrend: (json['growth_trend'] as List)
            .map((e) => GrowthDataPoint.fromJson(e))
            .toList(),
      );
}

class MultipleSimulationResponse {
  final String message;
  final List<SimulationResult> results;

  MultipleSimulationResponse({required this.message, required this.results});

  factory MultipleSimulationResponse.fromJson(Map<String, dynamic> json) =>
      MultipleSimulationResponse(
        message: json['message'],
        results: (json['results'] as List)
            .map((e) => SimulationResult.fromJson(e))
            .toList(),
      );
}

class ClientDepositResponse {
  final String message;
  final Client client;

  ClientDepositResponse({required this.message, required this.client});

  factory ClientDepositResponse.fromJson(Map<String, dynamic> json) =>
      ClientDepositResponse(
        message: json['message'],
        client: Client.fromJson(json['client']),
      );
}

class PortfolioTransferResponse {
  final String message;
  final Portfolio portfolio;
  final double clientCash;

  PortfolioTransferResponse({
    required this.message,
    required this.portfolio,
    required this.clientCash,
  });

  factory PortfolioTransferResponse.fromJson(Map<String, dynamic> json) =>
      PortfolioTransferResponse(
        message: json['message'],
        portfolio: Portfolio.fromJson(json['portfolio']),
        clientCash: json['client_cash'],
      );
}

class ErrorResponse {
  final String message;
  final String? error;
  final String? code;

  ErrorResponse({required this.message, this.error, this.code});
  String toString() =>
      'ErrorResponse(message: $message, error: $error, code: $code)';

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    message: json['message'],
    error: json['error'],
    code: json['code'],
  );
}

// API Client Class
class InvestEaseApiClient {
  static const String baseUrl =
      'https://2dcq63co40.execute-api.us-east-1.amazonaws.com/dev';
  String _jwtToken = SecretsRBC['jwtToken']!;

  void setJwtToken(String token) {
    _jwtToken = token;
  }

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    headers['Authorization'] = 'Bearer $_jwtToken';
    return headers;
  }

  Future<TeamAuthResponse> registerTeam(TeamRegistration registration) async {
    final response = await http.post(
      Uri.parse('$baseUrl/teams/register'),
      headers: _getHeaders(),
      body: jsonEncode(registration.toJson()),
    );
    if (response.statusCode == 201) {
      return TeamAuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Client> createClient(ClientCreate clientCreate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clients'),
      headers: _getHeaders(),
      body: jsonEncode(clientCreate.toJson()),
    );
    if (response.statusCode == 201) {
      return Client.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<List<Client>> getClients() async {
    final response = await http.get(
      Uri.parse('$baseUrl/clients'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Client.fromJson(e)).toList();
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Client> getClient(String clientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/clients/$clientId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Client> updateClient(
    String clientId,
    ClientUpdate clientUpdate,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clients/$clientId'),
      headers: _getHeaders(),
      body: jsonEncode(clientUpdate.toJson()),
    );
    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Map<String, dynamic>> deleteClient(String clientId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/clients/$clientId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<ClientDepositResponse> depositToClient(
    String clientId,
    double amount,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clients/$clientId/deposit'),
      headers: _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );
    if (response.statusCode == 200) {
      return ClientDepositResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Portfolio> createPortfolio(
    String clientId,
    PortfolioCreate portfolioCreate,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clients/$clientId/portfolios'),
      headers: _getHeaders(),
      body: jsonEncode(portfolioCreate.toJson()),
    );
    if (response.statusCode == 201) {
      return Portfolio.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<List<Portfolio>> getPortfolios(String clientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/clients/$clientId/portfolios'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Portfolio.fromJson(e)).toList();
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Portfolio> getPortfolio(String portfolioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/portfolios/$portfolioId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return Portfolio.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<MultipleSimulationResponse> simulatePortfolios(
    String clientId,
    SimulationRequest request,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/client/$clientId/simulate',
      ), // Note: YAML has /client/, assuming it's /clients/
      headers: _getHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return MultipleSimulationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<PortfolioTransferResponse> transferToPortfolio(
    String portfolioId,
    double amount,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/portfolios/$portfolioId/transfer'),
      headers: _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );
    if (response.statusCode == 200) {
      return PortfolioTransferResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Map<String, dynamic>> withdrawFromPortfolio(
    String portfolioId,
    double amount,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/portfolios/$portfolioId/withdraw'),
      headers: _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Map<String, dynamic>> getPortfolioAnalysis(String portfolioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/portfolios/$portfolioId/analysis'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ErrorResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Client?> getClientByEmail(String email) async {
    List<Client> all = await getClients();
    print('Searching for client with email: $email');
    try {
      return all.firstWhere((client) => client.email == email);
    } catch (e) {
      print('No client found with email $email: $e');
      return null;
    }
  }
}
