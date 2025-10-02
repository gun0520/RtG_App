import 'package:flutter/material.dart';
import 'fuel_record_input_screen.dart';
import 'fuel_history_screen.dart';
import 'vehicle_settings_screen.dart';
import '../viewmodels/driving_view_model.dart';
import 'package:provider/provider.dart';

class DrivingScreen extends StatefulWidget {
  const DrivingScreen({super.key});

  @override
  State<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  @override
  void initState() {
    super.initState();
    //ビルド後にViewModelの初期データ読み込みを呼び出す
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DrivingViewModel>(context, listen: false).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Consumerを使ってViewModelの変更を監視
    return Consumer<DrivingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('走行画面'),
            actions: [_buildSettingsMenu(context)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildFuelGauge(viewModel),
                const SizedBox(height: 24),
                _buildInfoCard(viewModel),
                const Spacer(),
                _buildActionButtons(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFuelGauge(DrivingViewModel viewModel) {
    return Column(
      children: [
        Text('ガソリン残量', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 180,
              width: 180,
              child: CircularProgressIndicator(
                value: viewModel.fuelPercentage,
                strokeWidth: 15,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text(
              '${(viewModel.fuelPercentage * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${(viewModel.remainingFuel.toStringAsFixed(1))}L',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildInfoCard(DrivingViewModel viewModel) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn(
              '航続可能距離',
              viewModel.range.toStringAsFixed(0),
              'km',
            ),
            _buildInfoColumn(
              '今回の走行距離',
              viewModel.tripDistance.toStringAsFixed(1),
              'km',
            ),
            _buildInfoColumn(
              '登録中の燃費',
              viewModel.settings!.manualFuelEconomy.toStringAsFixed(1),
              'km/L',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text('$value $unit', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget _buildActionButtons(DrivingViewModel viewModel) {
    return Column(
      children: [
        //走行開始/停止ボタン
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.isTracking ? Colors.red : Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () => viewModel.toggleDriving(),
          child: Text(
            viewModel.isTracking ? '走行停止' : '走行開始',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        //給油記録ボタン
        OutlinedButton.icon(
          icon: const Icon(Icons.local_gas_station),
          label: const Text('給油記録'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => FuelRecordInputScreen()));
          },
        ),
      ],
    );
  }

  PopupMenuButton<int> _buildSettingsMenu(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (item) {
        switch (item) {
          case 0:
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VehicleSettingsScreen()),
            );
            break;
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FuelHistoryScreen()),
            );
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(value: 0, child: Text('車両設定')),
        const PopupMenuItem<int>(value: 1, child: Text('給油履歴')),
      ],
    );
  }
}
