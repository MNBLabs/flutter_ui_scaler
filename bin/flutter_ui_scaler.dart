// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';

const _yamlFile = '.flutter_ui_scaler.yaml';

void main(List<String> args) async {
  final p = ArgParser()
    ..addOption(
      'set-des-res',
      help: 'Set design resolution as WxH (e.g., 440x956).',
    )
    ..addOption(
      'set-clamp',
      help: 'Set clamp as MIN..MAX (e.g., 0.9..1.15).',
    )
    ..addFlag(
      'show',
      help: 'Print current config if present.',
      negatable: false,
    )
    ..addFlag('help', abbr: 'h', negatable: false);

  final r = p.parse(args);

  if (r['help'] as bool || args.isEmpty) {
    _printUsage(p);
    exit(0);
  }

  final cfg = await _readConfig();

  if (r.wasParsed('set-des-res')) {
    final spec = (r['set-des-res'] as String)
        .toLowerCase()
        .replaceAll(' ', '')
        .split('x');
    if (spec.length != 2) _fail('Bad --set-des-res. Use WxH like 440x956.');
    final w = double.tryParse(spec[0]);
    final h = double.tryParse(spec[1]);
    if (w == null || h == null) _fail('Width/height must be numbers.');
    cfg['figmaW'] = w;
    cfg['figmaH'] = h;
  }

  if (r.wasParsed('set-clamp')) {
    final spec = (r['set-clamp'] as String)
        .toLowerCase()
        .replaceAll(' ', '')
        .split('..');
    if (spec.length != 2) {
      _fail('Bad --set-clamp. Use MIN..MAX like 0.9..1.15.');
    }
    final lo = double.tryParse(spec[0]);
    final hi = double.tryParse(spec[1]);
    if (lo == null || hi == null) _fail('Clamp values must be numbers.');
    cfg['minScale'] = lo;
    cfg['maxScale'] = hi;
  }

  if (r['show'] as bool) {
    if (cfg.isEmpty) {
      print('No $_yamlFile found.');
    } else {
      print('$_yamlFile:\n$cfg');
    }
  }

  if (r.wasParsed('set-des-res') || r.wasParsed('set-clamp')) {
    await _writeConfig(cfg);
    print('Updated $_yamlFile → $cfg');
    _printHowToUse();
  }
}

void _printUsage(ArgParser p) {
  print('flutter_ui_scaler — project helper\n');
  print(p.usage);
  print('\nExamples:');
  print('  flutter_ui_scaler --set-des-res 440x956');
  print('  flutter_ui_scaler --set-clamp 0.9..1.15');
  print('  flutter_ui_scaler --show');
}

Never _fail(String msg) {
  stderr.writeln('Error: $msg');
  exit(64);
}

Future<Map<String, dynamic>> _readConfig() async {
  final f = File(_yamlFile);
  if (!await f.exists()) return {};
  final lines = await f.readAsLines();
  final map = <String, dynamic>{};
  for (final line in lines) {
    final l = line.trim();
    if (l.isEmpty || l.startsWith('#')) continue;
    final i = l.indexOf(':');
    if (i <= 0) continue;
    final k = l.substring(0, i).trim();
    final v = l.substring(i + 1).trim();
    map[k] = double.tryParse(v) ?? v;
  }
  return map;
}

Future<void> _writeConfig(Map<String, dynamic> cfg) async {
  final f = File(_yamlFile);
  final b = StringBuffer()
    ..writeln('# Project defaults for flutter_ui_scaler')
    ..writeln('figmaW: ${cfg['figmaW'] ?? 440}')
    ..writeln('figmaH: ${cfg['figmaH'] ?? 956}')
    ..writeln('minScale: ${cfg['minScale'] ?? 0.9}')
    ..writeln('maxScale: ${cfg['maxScale'] ?? 1.15}');
  await f.writeAsString(b.toString());
}

void _printHowToUse() {
  print('''
Add these defaults when you wrap your app:

  UiScaleScope(
    figmaW: <from $_yamlFile>,
    figmaH: <from $_yamlFile>,
    child: MaterialApp(...),
  )

This file keeps your team aligned. Runtime still reads values
from UiScaleScope; nothing magic happens outside your app code.
''');
}
