import 'dart:convert';
import 'dart:io';

const int port = 5555;
const String dbPath = 'database.json';
const String webBuildPath = 'build/web';

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Server running on port $port');

  // Ensure database file exists with correct structure
  final dbFile = File(dbPath);
  if (!await dbFile.exists()) {
    await dbFile.writeAsString(jsonEncode({
      'users': [],
      'messages': [],
      'projects': [],
    }));
  } else {
    // Migrate if needed
    try {
      final content = await dbFile.readAsString();
      final data = jsonDecode(content);
      bool modified = false;
      if (!data.containsKey('users')) { data['users'] = []; modified = true; }
      if (!data.containsKey('messages')) { data['messages'] = []; modified = true; }
      if (!data.containsKey('projects')) { data['projects'] = []; modified = true; }
      if (modified) {
        await dbFile.writeAsString(jsonEncode(data));
      }
    } catch (_) {}
  }

  await for (HttpRequest request in server) {
    try {
      await handleRequest(request);
    } catch (e) {
      print('Error handling request: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      await request.response.close();
    }
  }
}

Future<void> handleRequest(HttpRequest request) async {
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');

  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }

  final path = request.uri.path;

  if (path == '/api/register' && request.method == 'POST') {
    await handleRegister(request);
    return;
  } else if (path == '/api/login' && request.method == 'POST') {
    await handleLogin(request);
    return;
  } else if (path == '/api/contact' && request.method == 'POST') {
    await handleContact(request);
    return;
  } else if (path == '/api/launch' && request.method == 'POST') {
    await handleLaunch(request);
    return;
  }

  await serveStaticFile(request);
}

Future<void> handleRegister(HttpRequest request) async {
  final content = await utf8.decoder.bind(request).join();
  final data = jsonDecode(content);
  final username = data['username']?.toString().trim();
  final password = data['password']?.toString().trim();

  if (username == null || username.isEmpty || password == null || password.isEmpty) {
    sendJson(request, HttpStatus.badRequest, {'success': false, 'message': 'Username and password are required'});
    return;
  }

  final file = File(dbPath);
  final dbData = jsonDecode(await file.readAsString());
  final List users = dbData['users'] ?? [];

  final userExists = users.any((u) => u['username'] == username);
  if (userExists) {
    sendJson(request, HttpStatus.conflict, {'success': false, 'message': 'Username already exists'});
    return;
  }

  users.add({'username': username, 'password': password});
  dbData['users'] = users;
  await file.writeAsString(jsonEncode(dbData));

  sendJson(request, HttpStatus.ok, {'success': true, 'message': 'Registration successful'});
}

Future<void> handleLogin(HttpRequest request) async {
  final content = await utf8.decoder.bind(request).join();
  final data = jsonDecode(content);
  final username = data['username']?.toString().trim();
  final password = data['password']?.toString().trim();

  if (username == null || username.isEmpty || password == null || password.isEmpty) {
    sendJson(request, HttpStatus.badRequest, {'success': false, 'message': 'Username and password are required'});
    return;
  }

  final file = File(dbPath);
  final dbData = jsonDecode(await file.readAsString());
  final List users = dbData['users'] ?? [];

  final user = users.firstWhere(
    (u) => u['username'] == username && u['password'] == password,
    orElse: () => null,
  );

  if (user == null) {
    sendJson(request, HttpStatus.unauthorized, {'success': false, 'message': 'Invalid username or password'});
    return;
  }

  sendJson(request, HttpStatus.ok, {'success': true, 'message': 'Login successful', 'username': username});
}

Future<void> handleContact(HttpRequest request) async {
  final content = await utf8.decoder.bind(request).join();
  final data = jsonDecode(content);
  
  final name = data['name']?.toString().trim();
  final email = data['email']?.toString().trim();
  final message = data['message']?.toString().trim();

  if (name == null || name.isEmpty || email == null || email.isEmpty || message == null || message.isEmpty) {
    sendJson(request, HttpStatus.badRequest, {'success': false, 'message': 'All fields are required'});
    return;
  }

  final file = File(dbPath);
  final dbData = jsonDecode(await file.readAsString());
  final List messages = dbData['messages'] ?? [];

  messages.add({
    'name': name,
    'email': email,
    'message': message,
    'timestamp': DateTime.now().toIso8601String(),
  });
  dbData['messages'] = messages;
  await file.writeAsString(jsonEncode(dbData));

  sendJson(request, HttpStatus.ok, {'success': true, 'message': 'Message sent successfully'});
}

Future<void> handleLaunch(HttpRequest request) async {
  final content = await utf8.decoder.bind(request).join();
  final data = jsonDecode(content);

  final title = data['title']?.toString().trim();
  final description = data['description']?.toString().trim();
  final budget = data['budget']?.toString().trim();
  final platform = data['platform']?.toString().trim();
  final contact = data['contact']?.toString().trim();

  if (title == null || title.isEmpty || description == null || description.isEmpty || contact == null || contact.isEmpty) {
    sendJson(request, HttpStatus.badRequest, {'success': false, 'message': 'Title, description, and contact info are required'});
    return;
  }

  final file = File(dbPath);
  final dbData = jsonDecode(await file.readAsString());
  final List projects = dbData['projects'] ?? [];

  projects.add({
    'title': title,
    'description': description,
    'budget': budget,
    'platform': platform,
    'contact': contact,
    'timestamp': DateTime.now().toIso8601String(),
  });
  dbData['projects'] = projects;
  await file.writeAsString(jsonEncode(dbData));

  sendJson(request, HttpStatus.ok, {'success': true, 'message': 'Project proposal submitted successfully'});
}

void sendJson(HttpRequest request, int statusCode, Map<String, dynamic> body) {
  request.response.statusCode = statusCode;
  request.response.headers.contentType = ContentType.json;
  request.response.write(jsonEncode(body));
  request.response.close();
}

Future<void> serveStaticFile(HttpRequest request) async {
  String filePath = request.uri.path;
  if (filePath == '/' || filePath.isEmpty) {
    filePath = '/index.html';
  }

  final file = File('$webBuildPath$filePath');

  if (await file.exists()) {
    ContentType contentType = ContentType.binary;
    if (filePath.endsWith('.html')) {
      contentType = ContentType.html;
    } else if (filePath.endsWith('.js')) {
      contentType = ContentType('application', 'javascript', charset: 'utf-8');
    } else if (filePath.endsWith('.css')) {
      contentType = ContentType('text', 'css', charset: 'utf-8');
    } else if (filePath.endsWith('.png')) {
      contentType = ContentType('image', 'png');
    } else if (filePath.endsWith('.svg')) {
      contentType = ContentType('image', 'svg+xml');
    }

    request.response.headers.contentType = contentType;
    await file.openRead().pipe(request.response);
  } else {
    final indexFile = File('$webBuildPath/index.html');
    if (await indexFile.exists()) {
      request.response.headers.contentType = ContentType.html;
      await indexFile.openRead().pipe(request.response);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
      await request.response.close();
    }
  }
}
