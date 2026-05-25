import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

part 'product_form_mixin.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView(this.product, {super.key});

  final ProductModel? product;

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> with ProductFormMixin {
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? context.l10n.productsEditTitle : context.l10n.productsCreateTitle,
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
              kAppButtonFabClearance,
            ),
            children: [
              ListenableBuilder(
                listenable: Listenable.merge([
                  nameCtr,
                  priceCtr,
                  categoryNotifier,
                  unitNotifier,
                  iconNotifier,
                ]),
                builder: (context, _) {
                  return BlocBuilder<ProductFormCubit, ProductFormState>(
                    bloc: cubit,
                    buildWhen: (a, b) => a.photoUrl != b.photoUrl,
                    builder: (_, state) {
                      return ProductPreviewCard(
                        name: nameCtr.text,
                        category: categoryNotifier.value,
                        unit: unitNotifier.value,
                        price: priceCtr.text,
                        icon: iconNotifier.value,
                        photoUrl: state.photoUrl,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x4),
              ValueListenableBuilder<ProductCategory>(
                valueListenable: categoryNotifier,
                builder: (_, category, _) {
                  return ProductCategorySelector(
                    selected: category,
                    onChanged: onCategoryChanged,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                context.l10n.productsPhotoSectionLabel,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: BlocBuilder<ProductFormCubit, ProductFormState>(
                      bloc: cubit,
                      buildWhen: (a, b) =>
                          a.photoUrl != b.photoUrl ||
                          a.isUploading != b.isUploading ||
                          a.icon != b.icon,
                      builder: (_, state) {
                        return ProductPhotoPicker(
                          initialUrl: state.photoUrl,
                          isLoading: state.isUploading,
                          icon: state.icon,
                          onPicked: (file) {
                            iconNotifier.value = null;
                            cubit.uploadPhoto(file);
                          },
                          onDeleted: cubit.removePhoto,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.productsIconPickerLabel,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        ListenableBuilder(
                          listenable: Listenable.merge([categoryNotifier, iconNotifier]),
                          builder: (_, _) {
                            return ProductIconPicker(
                              emojis: emojisByCategory[categoryNotifier.value] ?? [],
                              selected: iconNotifier.value,
                              onChanged: (v) {
                                iconNotifier.value = v;
                                cubit.setIcon(v);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppTextField(
                controller: nameCtr,
                label: context.l10n.productsNameLabel,
                hintText: context.l10n.productsNameHint,
                maxLength: 80,
                validator: (v) => InputValidators.emptyValidator(v, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              ValueListenableBuilder<ProductUnit>(
                valueListenable: unitNotifier,
                builder: (_, unit, _) {
                  return ProductUnitSelector(
                    selected: unit,
                    onChanged: (u) => unitNotifier.value = u,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x4),
              ValueListenableBuilder<ProductUnit>(
                valueListenable: unitNotifier,
                builder: (_, unit, _) {
                  return AppTextField(
                    controller: priceCtr,
                    label:
                        '${context.l10n.productsPriceLabel} (${context.l10n.currencyLabel} / ${unit.localizedShortName(context.l10n)})',
                    hintText: context.l10n.productsPriceHint,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validatePrice,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: descriptionCtr,
                label: context.l10n.productsDescriptionLabel,
                hintText: context.l10n.productsDescriptionHint,
                maxLines: 3,
                maxLength: 300,
              ),
              const SizedBox(height: AppSpacing.x4),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: BlocConsumer<ProductFormCubit, ProductFormState>(
            bloc: cubit,
            listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
            listener: (context, state) {
              final status = state.submitStatus;
              if (status is RequestSuccess<ProductModel>) {
                context.pop(status.data);
              } else if (status is RequestFailure<ProductModel>) {
                context.handleError(status.exception);
              }
            },
            buildWhen: (a, b) => a.isSubmitting != b.isSubmitting,
            builder: (_, state) {
              return AppButton(
                onPressed: submit,
                isLoading: state.isSubmitting,
                child: Text(
                  isEdit ? context.l10n.productsUpdateButton : context.l10n.productsCreateButton,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
