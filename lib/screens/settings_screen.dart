import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _fontOptions = [
    'Roboto',
    'Lato',
    'OpenSans',
    'Montserrat',
    'Raleway',
  ];
  String _selectedFont = 'Roboto';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFont = prefs.getString('fontFamily') ?? 'Roboto';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de tema
            const Text(
              'Tema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Opción de modo claro/oscuro
            SwitchListTile(
              title: const Text('Modo oscuro'),
              subtitle: Text(
                themeProvider.isDarkMode
                    ? 'El tema oscuro está activado'
                    : 'El tema claro está activado',
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
              ),
            ),
            
            const Divider(),
            
            // Sección de color personalizado
            const Text(
              'Color Personalizado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              children: [
                _buildColorOption(Colors.blue, themeProvider),
                _buildColorOption(Colors.red, themeProvider),
                _buildColorOption(Colors.green, themeProvider),
                _buildColorOption(Colors.orange, themeProvider),
                _buildColorOption(Colors.purple, themeProvider),
                _buildColorOption(Colors.teal, themeProvider),
              ],
            ),
            
            const Divider(),
            
            // Sección de fuente
            const Text(
              'Fuente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tipo de Fuente',
              ),
              value: _selectedFont,
              items: _fontOptions.map((font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(
                    'Fuente $font',
                    style: TextStyle(fontFamily: font),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFont = value;
                  });
                  themeProvider.setFontFamily(value);
                }
              },
            ),
            
            const Divider(),
            
            // Texto de muestra para previsualizar los cambios
            const SizedBox(height: 24),
            const Text(
              'Vista previa:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Este es un texto de muestra para ver cómo se ve la fuente y el tema seleccionados.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, ThemeProvider themeProvider) {
    final bool isSelected = themeProvider.customPrimaryColor == color;
    
    return GestureDetector(
      onTap: () {
        themeProvider.setCustomPrimaryColor(color);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
      ),
    );
  }
}