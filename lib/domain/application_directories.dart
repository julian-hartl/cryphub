import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_directories.freezed.dart';

@freezed
class ApplicationDirectories with _$ApplicationDirectories {
  const factory ApplicationDirectories({
    required String tempDir,
    required String docDir,
  }) = _ApplicationDirectories;
}
