import '../models/models.dart';

const defaultProfile = Profile(
  name: 'Fakhry Firdaus',
  bio:
      'Software Engineer & Dosen. Suka berbagi ilmu tentang Flutter '
      'dan pengembangan aplikasi mobile.',
);

const dummyProjects = <Project>[
  Project(
    id: 'p1',
    title: 'Aplikasi Absensi Kampus',
    description:
        'Aplikasi presensi mahasiswa berbasis QR code dengan '
        'rekap kehadiran otomatis per mata kuliah.',
    techStack: ['Flutter', 'Firebase', 'Provider'],
  ),
  Project(
    id: 'p2',
    title: 'Katalog UMKM Jember',
    description:
        'Katalog digital untuk membantu UMKM lokal memasarkan '
        'produknya secara online.',
    techStack: ['Flutter', 'REST API', 'Dio'],
  ),
  Project(
    id: 'p3',
    title: 'Monitoring Kandang Pintar',
    description:
        'Dashboard mobile untuk memantau suhu dan kelembapan '
        'kandang secara real-time.',
    techStack: ['Flutter', 'MQTT', 'Cloud'],
  ),
];
