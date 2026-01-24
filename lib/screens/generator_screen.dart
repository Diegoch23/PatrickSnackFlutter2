import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';

class GeneratorScreen extends StatefulWidget {
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  // --- INYECCIÓN DE DEPENDENCIAS Y CONTROLADORES ---
  
  // Servicio para la comunicación con el Backend
  final _api = ApiService();
  
  // Controlador para la captura de widgets en mapas de bits (bitmap)
  final _screenshotController = ScreenshotController();
  
  // Referencia a la caja de persistencia local (NoSQL) para gestión offline
  final Box _productsBox = Hive.box('products_cache');

  // --- VARIABLES DE ESTADO ---
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _synchronizeProducts();
  }

  /// Ejecuta la estrategia de sincronización de datos "Network First".
  /// 1. Intenta obtener los datos frescos de la API.
  /// 2. Si hay éxito, actualiza la caché local y el estado de la vista.
  /// 3. Si falla la red, recupera los datos persistentes de la caché local (Hive).
  _synchronizeProducts() async {
    setState(() => isLoading = true);
    
    // Fase 1: Sincronización Remota
    try {
      final data = await _api.getProducts();
      if (data.isNotEmpty) {
        // Actualización de la persistencia local
        await _productsBox.put('list', data);
        
        if (mounted) {
          setState(() {
            products = data;
            isLoading = false;
          });
        }
        return; // Salida temprana si hubo éxito online
      }
    } catch (e) {
      debugPrint("Excepción en sincronización remota: $e");
    }

    // Fase 2: Recuperación Local (Fallback)
    final cachedData = _productsBox.get('list');
    if (mounted) {
      setState(() {
        if (cachedData != null) products = List<dynamic>.from(cachedData);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generador de Códigos")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Feedback de carga
          : products.isEmpty
              ? Center(child: Text("No se encontraron registros sincronizados."))
              : ListView.builder(
                  // Renderizado eficiente de listas bajo demanda
                  padding: EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    
                    return Card(
                      elevation: 3, // Elevación sutil según Material Design
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Invocación del modal de generación QR/Code128
                          _showBarcodeModal(
                            product['sku'].toString(), 
                            product['name']
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Componente visual personalizado para el producto
                              _buildProductIcon(),
                              
                              SizedBox(width: 15),
                              
                              // Columna de información textual
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.w700, // Tipografía con peso visual alto
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    
                                    // Contenedor decorado para el SKU con tipografía técnica
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "SKU: ${product['sku']}",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                          fontFamily: 'monospace', // Fuente monoespaciada para datos técnicos
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Indicador de affordance (navegabilidad)
                              Icon(Icons.chevron_right, size: 24, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  /// Construye el identificador visual del ítem.
  /// Aplica una transformación geométrica (rotación) al ícono de gráfico
  /// para simular semánticamente un código de barras estilizado.
  Widget _buildProductIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1), // Fondo traslúcido para jerarquía visual
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Center(
        // Transformación de 90 grados (PI/2 radianes) al icono de estadísticas
        child: Transform.rotate(
          angle: 1.5708, 
          child: Icon(
            Icons.bar_chart_rounded, 
            color: Colors.blueAccent, 
            size: 28
          ),
        ),
      ),
    );
  }

  /// Despliega un 'Modal Bottom Sheet' que contiene el widget de generación de código.
  /// Permite la visualización y posterior captura del código generado.
  void _showBarcodeModal(String sku, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el modal se ajuste al contenido dinámico
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Código Generado", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              
              // Widget Screenshot: Envuelve el árbol de widgets a capturar
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: Colors.white, // Fondo opaco obligatorio para el contraste del escáner
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Renderizado del código Code128 vectorial
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: sku,
                        width: 300,
                        height: 100,
                        drawText: true,
                        style: TextStyle(fontSize: 14, letterSpacing: 2),
                      ),
                      SizedBox(height: 15),
                      Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Botón de acción principal
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _saveBarcodeToGallery();
                    Navigator.pop(context); // Cierra la pila de navegación del modal
                  },
                  icon: Icon(Icons.save_alt),
                  label: Text("Guardar en Galería", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Captura el contexto gráfico actual mediante [ScreenshotController] 
  /// y persiste el buffer de bytes resultante en el almacenamiento externo del dispositivo.
  Future<void> _saveBarcodeToGallery() async {
    try {
      // Delay técnico para asegurar el renderizado completo del frame antes de capturar
      await Future.delayed(Duration(milliseconds: 150));
      
      final imageBytes = await _screenshotController.capture();
      
      if (imageBytes != null) {
        // Invocación a la API nativa del sistema para guardar imágenes
        await Gal.putImageBytes(imageBytes);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Imagen guardada exitosamente"),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              )
          );
        }
      }
    } catch (e) {
      debugPrint("Error de E/S al guardar imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la imagen"), backgroundColor: Colors.red)
      );
    }
  }
}