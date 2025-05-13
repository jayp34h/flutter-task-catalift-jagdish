import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int enrolledCount;
  final List<String> tags;
  final String instructorName;
  final String instructorRole;
  final double instructorRating;
  final int instructorExperienceYears;
  final List<String> whatYouWillLearn;
  final int durationHours;
  final int lessonCount;
  final bool hasDownloadableResources;
  final bool hasCertificate;
  final bool isBookmarked;
  final bool isHighlyEnrolled;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.enrolledCount,
    required this.tags,
    required this.instructorName,
    required this.instructorRole,
    required this.instructorRating,
    required this.instructorExperienceYears,
    required this.whatYouWillLearn,
    required this.durationHours,
    required this.lessonCount,
    this.hasDownloadableResources = false,
    this.hasCertificate = false,
    this.isBookmarked = false,
    this.isHighlyEnrolled = false,
  });
}

// Dummy courses data
final List<Course> dummyCourses = [
  Course(
    id: '1',
    title: 'Artificial Intelligence',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    price: 1500,
    rating: 4.5,
    enrolledCount: 8374,
    tags: ['AI & ML', 'Programming'],
    instructorName: 'Dr. Sarah Johnson',
    instructorRole: 'AI Researcher & Professor',
    instructorRating: 4.8,
    instructorExperienceYears: 12,
    whatYouWillLearn: [
      'Understand the fundamentals of artificial intelligence',
      'Build and deploy machine learning models',
      'Apply AI techniques to real-world problems',
      'Master neural networks and deep learning concepts',
    ],
    durationHours: 42,
    lessonCount: 84,
    hasDownloadableResources: true,
    hasCertificate: true,
    isBookmarked: true,
    isHighlyEnrolled: true,
  ),
  Course(
    id: '2',
    title: 'User Interface and User Experience',
    description: 'Learn the principles of UI/UX design and create beautiful, user-friendly interfaces that enhance user experience and drive engagement.',
    price: 1200,
    rating: 4.7,
    enrolledCount: 5632,
    tags: ['UI/UX', 'Design'],
    instructorName: 'Alex Chen',
    instructorRole: 'Senior UX Designer',
    instructorRating: 4.9,
    instructorExperienceYears: 8,
    whatYouWillLearn: [
      'Master UI/UX design principles',
      'Create wireframes and prototypes',
      'Conduct user research and testing',
      'Design responsive interfaces for web and mobile',
    ],
    durationHours: 38,
    lessonCount: 72,
    hasDownloadableResources: true,
    hasCertificate: true,
    isHighlyEnrolled: false,
  ),
  Course(
    id: '3',
    title: 'Computer Engineering',
    description: 'Dive deep into computer engineering concepts, from hardware architecture to software development and system design.',
    price: 1500,
    rating: 4.3,
    enrolledCount: 3845,
    tags: ['Programming', 'Engineering'],
    instructorName: 'Prof. Michael Lee',
    instructorRole: 'Computer Engineering Professor',
    instructorRating: 4.6,
    instructorExperienceYears: 15,
    whatYouWillLearn: [
      'Understand computer architecture and organization',
      'Design and implement digital systems',
      'Master embedded systems programming',
      'Learn about computer networks and security',
    ],
    durationHours: 56,
    lessonCount: 98,
    hasDownloadableResources: true,
    hasCertificate: true,
    isHighlyEnrolled: true,
  ),
  Course(
    id: '4',
    title: 'Digital Marketing Mastery',
    description: 'Learn how to create effective digital marketing strategies, leverage social media, and drive conversions through data-driven approaches.',
    price: 1100,
    rating: 4.6,
    enrolledCount: 7290,
    tags: ['Marketing', 'Business'],
    instructorName: 'Emma Rodriguez',
    instructorRole: 'Digital Marketing Strategist',
    instructorRating: 4.7,
    instructorExperienceYears: 10,
    whatYouWillLearn: [
      'Create comprehensive digital marketing strategies',
      'Master SEO and content marketing techniques',
      'Leverage social media for brand growth',
      'Analyze marketing data and optimize campaigns',
    ],
    durationHours: 32,
    lessonCount: 64,
    hasDownloadableResources: true,
    hasCertificate: true,
    isHighlyEnrolled: false,
  ),
  Course(
    id: '5',
    title: 'Public Speaking and Communication',
    description: 'Develop powerful public speaking skills, overcome stage fright, and learn how to communicate effectively in professional settings.',
    price: 900,
    rating: 4.8,
    enrolledCount: 9120,
    tags: ['Public Speaking', 'Communication'],
    instructorName: 'James Wilson',
    instructorRole: 'Communication Coach',
    instructorRating: 4.9,
    instructorExperienceYears: 14,
    whatYouWillLearn: [
      'Master the art of public speaking',
      'Overcome anxiety and stage fright',
      'Structure compelling presentations',
      'Use body language and voice modulation effectively',
    ],
    durationHours: 24,
    lessonCount: 48,
    hasDownloadableResources: false,
    hasCertificate: true,
    isHighlyEnrolled: true,
  ),
];
