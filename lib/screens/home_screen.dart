import 'package:flutter/material.dart';
import 'package:proyek/models/schedule_model.dart';
import 'package:proyek/services/schedule_service.dart';
import '../utils/constants.dart';
import 'schedule_create.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<List<Scheduleuser>>? schedule;

  @override
  void initState() {
    super.initState();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    setState(() {
      schedule = ApiSchedule.getSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Explore',
          style: AppTextStyles.kasteloButton.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Scheduleuser>>(
  future: schedule,
  builder: (context, snapshot) {

    /// Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    /// Error
    if (snapshot.hasError) {
      return const Center(
        child: Text("Error loading schedules"),
      );
    }

    /// Jika tidak ada schedule
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildEmptyState();
    }

    /// Jika ada schedule
    final data = snapshot.data!;

    return Column(
      children: [
        /// ListView schedule (dibungkus Expanded)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final schedule = data[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(schedule.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schedule.description),
                      const SizedBox(height: 5),
                      Text(
                        "${schedule.date.day}/${schedule.date.month}/${schedule.date.year}",
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await ApiSchedule.deleteSchedule(schedule.id);
                      await fetchSchedule();
                    },
                  ),
                ),
              );
            },
          ),
        ),

        /// Tombol-tombol di luar ListView
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement find friends
              },
              child: const Text("Find your Friends!"),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const addSchedule(),
                  ),
                );

                if (result == true) {
                  await fetchSchedule();
                }
              },
              child: const Text("Create your Schedule!"),
            ),
          ),
        ),
      ],
    );
  },
),
    );
  }

  /// UI jika schedule kosong
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const SizedBox(height: 40),

          /// Gambar profil
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey300,
              border: Border.all(
                color: AppColors.white,
                width: 4,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/grup.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 32),

          /// Text utama
          const Text(
            'Aha! You must be the new person!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'KasteloVultra',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          /// Deskripsi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "You're not following anyone or have created your own schedule, try to follow your friends, or create your own schedule using the button under this message.",
              style: AppTextStyles.kasteloSmall.copyWith(
                color: AppColors.grey600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          /// Tombol find friend
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Find your Friends!',
                style: AppTextStyles.kasteloButton.copyWith(
                  color: AppColors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Tombol create schedule
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () async {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const addSchedule(),
                  ),
                );

                /// Refresh setelah create schedule
                if (result == true) {
                  await fetchSchedule();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF007AFF),
                side: const BorderSide(
                  color: Color(0xFF007AFF),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.white,
              ),
              child: Text(
                'Create your Schedule!',
                style: AppTextStyles.kasteloButton.copyWith(
                  color: const Color(0xFF007AFF),
                  fontSize: 17,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
