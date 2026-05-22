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

class ProductFormView extends StatefulWidget {
  const ProductFormView(this.product, {super.key});

  final ProductModel? product;

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  late final ProductFormCubit _cubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameCtr;
  late final TextEditingController _priceCtr;
  late final TextEditingController _descriptionCtr;
  late ProductCategory _category;
  late ProductUnit _unit;

  @override
  void initState() {
    super.initState();
    final existing = widget.product;
    _cubit = ProductFormCubit(
      productRepository: GetIt.I<ProductRepository>(),
      existing: existing,
    );
    _formKey = GlobalKey<FormState>();
    _nameCtr = TextEditingController(text: existing?.name ?? '');
    _priceCtr = TextEditingController(
      text: existing != null ? existing.price.toString() : '',
    );
    _descriptionCtr = TextEditingController(text: existing?.description ?? '');
    _category = existing?.category ?? ProductCategory.drink;
    _unit = existing?.unit ?? ProductUnit.piece;
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _priceCtr.dispose();
    _descriptionCtr.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final photoUrl = _cubit.state.photoUrl;
    _cubit.submit(
      ProductCreateParam(
        name: _nameCtr.text.trim(),
        price: int.parse(_priceCtr.text.trim()),
        unit: _unit,
        category: _category,
        description: _descriptionCtr.text.trim().isEmpty ? null : _descriptionCtr.text.trim(),
        photoUrl: photoUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return BlocListener<ProductFormCubit, ProductFormState>(
      bloc: _cubit,
      listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
      listener: (context, state) {
        final status = state.submitStatus;
        if (status is RequestSuccess<ProductModel>) {
          context.pop(status.data);
        } else if (status is RequestFailure<ProductModel>) {
          context.handleError(status.exception);
        }
      },
      child: AppButtonScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              isEdit ? context.l10n.productsEditTitle : context.l10n.productsCreateTitle,
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                AppSpacing.x4,
                AppSpacing.x4,
                AppSpacing.x10,
              ),
              children: [
                BlocBuilder<ProductFormCubit, ProductFormState>(
                  bloc: _cubit,
                  buildWhen: (a, b) => a.photoUrl != b.photoUrl || a.isUploading != b.isUploading,
                  builder: (_, state) {
                    return ProductPhotoPicker(
                      initialUrl: state.photoUrl,
                      isLoading: state.isUploading,
                      onPicked: _cubit.uploadPhoto,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _nameCtr,
                  label: context.l10n.productsNameLabel,
                  hintText: context.l10n.productsNameHint,
                  maxLength: 80,
                  validator: (v) => InputValidators.emptyValidator(v, context),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _priceCtr,
                  label: context.l10n.productsPriceLabel,
                  hintText: context.l10n.productsPriceHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return context.l10n.authFieldRequired;
                    }
                    final parsed = int.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) {
                      return context.l10n.productsPriceInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                StatefulBuilder(
                  builder: (_, setState) => ProductCategorySelector(
                    selected: _category,
                    onChanged: (c) => setState(() => _category = c),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                StatefulBuilder(
                  builder: (_, setState) {
                    return ProductUnitSelector(
                      selected: _unit,
                      onChanged: (u) => setState(() => _unit = u),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _descriptionCtr,
                  label: context.l10n.productsDescriptionLabel,
                  hintText: context.l10n.productsDescriptionHint,
                  maxLines: 3,
                  maxLength: 300,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: kAppButtonFabLocation,
          floatingActionButton: BlocBuilder<ProductFormCubit, ProductFormState>(
            bloc: _cubit,
            buildWhen: (a, b) => a.isSubmitting != b.isSubmitting,
            builder: (_, state) {
              return AppButton(
                onPressed: _submit,
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
