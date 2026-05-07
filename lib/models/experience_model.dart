class Experience {
  final String id;
  final String type;
  final String company;
  final String role;
  final String duration;
  final String stipend;
  final String workMode;
  final String learnings;
  final String userName;
  final String userId;
  final bool approved;

  Experience({
    required this.id,
    required this.type,
    required this.company,
    required this.role,
    required this.duration,
    required this.stipend,
    required this.workMode,
    required this.learnings,
    required this.userName,
    required this.userId,
    required this.approved,
  });

  factory Experience.fromDoc(doc) {
    final data = doc.data();
    return Experience(
      id: doc.id,
      type: data['type'],
      company: data['company'],
      role: data['role'],
      duration: data['duration'],
      stipend: data['stipend'],
      workMode: data['workMode'],
      learnings: data['learnings'],
      userName: data['userName'],
      userId: data['userId'],
      approved: data['approved'],
    );
  }
}