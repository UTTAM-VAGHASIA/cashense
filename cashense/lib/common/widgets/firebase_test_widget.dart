import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/data/services/firebase_service.dart';

class FirebaseTestWidget extends StatefulWidget {
  const FirebaseTestWidget({super.key});

  @override
  FirebaseTestWidgetState createState() => FirebaseTestWidgetState();
}

class FirebaseTestWidgetState extends State<FirebaseTestWidget> {
  String _testResult = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firebase Configuration Test',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            _buildInfoRow('Current Flavor:', FlavorConfig.instance.name),
            _buildInfoRow(
              'Firebase Project:',
              FirebaseService.currentProjectId,
            ),
            _buildInfoRow('Bundle ID:', FlavorConfig.instance.bundleId),
            SizedBox(height: 16),
            if (_testResult.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testResult.contains('✅')
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testResult.contains('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(_testResult),
              ),
              SizedBox(height: 16),
            ],
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _testFirestoreConnection,
                  child: _isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Test Firestore'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testAuthConnection,
                  child: Text('Test Auth'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testFirestoreConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
    });

    try {
      // Test Firestore connection
      await FirebaseFirestore.instance.collection('test').add({
        'timestamp': FieldValue.serverTimestamp(),
        'flavor': FlavorConfig.instance.flavor.toString(),
        'message': 'Test from ${FlavorConfig.instance.name}',
      });

      setState(() {
        _testResult =
            '✅ Firestore connection successful!\nConnected to: ${FirebaseService.currentProjectId}';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Firestore connection failed:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAuthConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
    });

    try {
      // Test anonymous authentication
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      setState(() {
        _testResult =
            '✅ Authentication successful!\nUser ID: ${userCredential.user?.uid}\nProject: ${FirebaseService.currentProjectId}';
      });

      // Sign out after test
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      setState(() {
        _testResult = '❌ Authentication failed:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
