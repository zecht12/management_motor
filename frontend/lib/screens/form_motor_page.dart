import 'package:flutter/material.dart';
import '../models/motor_model.dart';
import '../services/api_service.dart';

class FormMotorPage extends StatefulWidget {
  final Motor? motor;
  const FormMotorPage({super.key, this.motor});

  @override
  State<FormMotorPage> createState() => _FormMotorPageState();
}

class _FormMotorPageState extends State<FormMotorPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.motor != null) {
      _idController.text = widget.motor!.idmotor;
      _namaController.text = widget.motor!.nama;
      _stokController.text = widget.motor!.stok.toString();
      _hargaController.text = widget.motor!.harga.toInt().toString();
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    bool success;
    
    if (widget.motor == null) {
      success = await ApiService().addMotor(
        _idController.text,
        _namaController.text,
        _stokController.text,
        _hargaController.text,
      );
    } else {
      success = await ApiService().updateMotor(
        widget.motor!.idmotor,
        _namaController.text,
        _stokController.text,
        _hargaController.text,
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan"), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menyimpan data"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.motor != null;
    final primaryColor = Colors.indigo;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(isEdit ? "Edit Motor" : "Tambah Motor"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(isEdit ? Icons.edit_note : Icons.add_circle_outline, color: Colors.white),
                  ),
                  title: Text(
                    isEdit ? "Perbarui Data Motor" : "Input Data Baru",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Pastikan data yang dimasukkan benar",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _idController,
                          decoration: InputDecoration(
                            labelText: 'ID Motor',
                            hintText: 'Misal: M001',
                            prefixIcon: const Icon(Icons.qr_code),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: !isEdit,
                            fillColor: isEdit ? Colors.grey[200] : Colors.white,
                          ),
                          enabled: !isEdit,
                          validator: (value) => value!.isEmpty ? 'ID harus diisi' : null,
                        ),
                        const SizedBox(height: 20),
                        
                        TextFormField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama Motor',
                            hintText: 'Misal: Honda Vario',
                            prefixIcon: const Icon(Icons.two_wheeler),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stokController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Stok',
                                  prefixIcon: const Icon(Icons.inventory),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => value!.isEmpty ? 'Wajib' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _hargaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Harga',
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => value!.isEmpty ? 'Wajib' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white, width: 2),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading 
                              ? const SizedBox(
                                  height: 20, width: 20, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                ) 
                              : Text(isEdit ? "UPDATE DATA" : "SIMPAN DATA", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}