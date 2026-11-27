import 'package:flutter/material.dart';
import '../config.dart';
import '../l10n/app_localizations.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import '../utils.dart';

Future<bool> _confirmDelete(BuildContext context, Admin a) async {
  final l = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.confirmDelete),
      content: Text('${a.name} (ID ${a.id})'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  late Future<List<Admin>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminService.getAdmins();
  }

  void _reload() {
    setState(() {
      _future = AdminService.getAdmins();
    });
  }

  Future<void> _openDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminDetailPage(id: id)),
    );
    if (mounted) _reload();
  }

  // DELETE admin dari daftar
  Future<void> _delete(Admin a) async {
    if (!await _confirmDelete(context, a)) return;
    try {
      final ok = await AdminService.deleteAdmin(a.id);
      if (!mounted) return;
      if (!ok) throw Exception(AppLocalizations.of(context)!.noData);
      showMessage(
        context,
        '${AppLocalizations.of(context)!.adminDeleted} (ID ${a.id})',
      );
      _reload();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: OutlinedButton.icon(
            onPressed: () => _openDetail(idAdmin),
            icon: const Icon(Icons.search),
            label: Text('${l.viewDetail} Admin ID $idAdmin'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Admin>>(
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
              final admins = snap.data!;
              if (admins.isEmpty) {
                return Center(child: Text(l.noData));
              }
              return ListView.builder(
                itemCount: admins.length,
                itemBuilder: (_, i) {
                  final a = admins[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${a.id}')),
                    title: Text(a.name),
                    subtitle: Text('${a.email} • ${a.department}'),
                    trailing: IconButton(
                      tooltip: l.delete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(a),
                    ),
                    onTap: () => _openDetail(a.id),
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

class AdminDetailPage extends StatefulWidget {
  final int id;
  const AdminDetailPage({super.key, required this.id});

  @override
  State<AdminDetailPage> createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  late Future<Admin> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminService.getAdmin(widget.id);
  }

  Future<void> _delete(Admin a) async {
    if (!await _confirmDelete(context, a)) return;
    try {
      final ok = await AdminService.deleteAdmin(a.id);
      if (!mounted) return;
      if (!ok) throw Exception(AppLocalizations.of(context)!.noData);
      showMessage(context, AppLocalizations.of(context)!.adminDeleted);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l.detailTitle} Admin ID ${widget.id}')),
      body: FutureBuilder<Admin>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text(errorText(snap.error!)));
          }
          final a = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${a.id}'),
                      Text('${l.tabAdmins}: ${a.name}'),
                      Text('${l.email}: ${a.email}'),
                      Text('${l.department}: ${a.department}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () => _delete(a),
                child: Text('DELETE: ${l.delete}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
