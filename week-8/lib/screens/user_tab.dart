import 'package:flutter/material.dart';
import '../config.dart';
import '../l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils.dart';

Future<List<User>> _loadUsers() async {
  final data = await ApiService.getUsers();
  return data.map((e) => User.fromJson(Map<String, dynamic>.from(e))).toList();
}

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadUsers();
  }

  void _reload() {
    setState(() {
      _future = _loadUsers();
    });
  }

  // POST: tambah user baru dengan ID dari NIM (1537)
  Future<void> _add() async {
    final l = AppLocalizations.of(context)!;
    try {
      await ApiService.createUser(
        'Muhammad Amizola Rahmandani',
        'amizola@example.com',
        id: idUser,
      );
      if (!mounted) return;
      showMessage(context, '${l.userAdded} (ID $idUser)');
      _reload();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _openDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailPage(id: id)),
    );
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.add),
                label: Text('${l.addUser} ID $idUser'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openDetail(idUser),
                icon: const Icon(Icons.search),
                label: Text('${l.viewDetail} ID $idUser'),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<User>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.errorMessage),
                      TextButton(onPressed: _reload, child: Text(l.retry)),
                    ],
                  ),
                );
              }
              final users = snap.data!;
              if (users.isEmpty) {
                return Center(child: Text(l.noData));
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final u = users[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${u.id}')),
                    title: Text(u.name),
                    subtitle: Text('${u.email} • ${u.city}'),
                    onTap: () => _openDetail(u.id),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserDetailPage extends StatefulWidget {
  final int id;
  const UserDetailPage({super.key, required this.id});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<User> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<User> _load() async =>
      User.fromJson(await ApiService.getUser(widget.id));

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _run(Future<void> Function() action, String success) async {
    try {
      await action();
      if (!mounted) return;
      showMessage(context, success);
      _reload();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  Future<void> _delete(User u) async {
    final l = AppLocalizations.of(context)!;
    try {
      final ok = await ApiService.deleteUser(u.id);
      if (!mounted) return;
      if (!ok) throw Exception(l.noData);
      showMessage(context, l.userDeleted);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l.detailTitle} ID ${widget.id}')),
      body: FutureBuilder<User>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text(errorText(snap.error!)));
          }
          final u = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${u.id}'),
                      Text('${l.tabUsers}: ${u.name}'),
                      Text('${l.email}: ${u.email}'),
                      Text('${l.city}: ${u.city}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _run(
                  () => ApiService.updateUser(
                    u.id,
                    'Amizola Rahmandani (Update)',
                    'amizola.update@example.com',
                  ),
                  l.userUpdated,
                ),
                child: Text(l.updatePut),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => _run(
                  () => ApiService.patchUser(
                    u.id,
                    '${u.name} - Flutter Developer',
                  ),
                  l.userPatched,
                ),
                child: Text(l.patchName),
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () => _delete(u),
                child: Text('DELETE: ${l.delete}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
