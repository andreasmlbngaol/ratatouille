import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/image/ratatouille_image_model.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
part 'step_with_images_model.g.dart';

@JsonSerializable()
class StepWithImagesModel {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String content;
  final List<RatatouilleImageModel> images;

  const StepWithImagesModel({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.content,
    required this.images
  });

  factory StepWithImagesModel.fromJson(Map<String, dynamic> json) =>
      _$StepWithImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$StepWithImagesModelToJson(this);

  StepWithImages toDomain() {
    return StepWithImages(
        id: id,
        recipeId: recipeId,
        stepNumber: stepNumber,
        content: content,
        images: images.map((image) => image.toDomain()).toList()
    );
  }

  factory StepWithImagesModel.fromDomain(StepWithImages step) {
    return StepWithImagesModel(
        id: step.id,
        recipeId: step.recipeId,
        stepNumber: step.stepNumber,
        content: step.content,
        images: step.images.map((image) =>
            RatatouilleImageModel.fromDomain(image)).toList()
    );
  }
}