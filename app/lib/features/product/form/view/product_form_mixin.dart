part of 'product_form_view.dart';

mixin ProductFormMixin on State<ProductFormView> {
  late final ProductFormCubit cubit;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameCtr;
  late final TextEditingController priceCtr;
  late final TextEditingController descriptionCtr;
  late final ValueNotifier<ProductCategory> categoryNotifier;
  late final ValueNotifier<ProductUnit> unitNotifier;
  late final ValueNotifier<String?> iconNotifier;
  late final Map<ProductCategory, List<String>> emojisByCategory;

  @override
  void initState() {
    super.initState();
    final existing = widget.product;
    final repo = GetIt.I<ProductRepository>();
    cubit = ProductFormCubit(
      productRepository: repo,
      existing: existing,
    );
    emojisByCategory = repo.getEmojisByCategory();
    formKey = GlobalKey();
    nameCtr = TextEditingController(text: existing?.name ?? '');
    priceCtr = TextEditingController(
      text: existing != null ? existing.price.toString() : '',
    );
    descriptionCtr = TextEditingController(text: existing?.description ?? '');
    categoryNotifier = ValueNotifier(existing?.category ?? ProductCategory.drink);
    unitNotifier = ValueNotifier(existing?.unit ?? ProductUnit.piece);
    iconNotifier = ValueNotifier(existing?.icon);
  }

  @override
  void dispose() {
    nameCtr.dispose();
    priceCtr.dispose();
    descriptionCtr.dispose();
    cubit.close();
    categoryNotifier.dispose();
    unitNotifier.dispose();
    iconNotifier.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    final photoUrl = cubit.state.photoUrl;
    cubit.submit(
      ProductCreateParam(
        name: nameCtr.text.trim(),
        price: int.parse(priceCtr.text.trim()),
        unit: unitNotifier.value,
        category: categoryNotifier.value,
        description: descriptionCtr.text.trim().isEmpty ? null : descriptionCtr.text.trim(),
        photoUrl: photoUrl,
        icon: photoUrl == null ? iconNotifier.value : null,
      ),
    );
  }

  String? validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return context.l10n.authFieldRequired;
    final parsed = int.tryParse(v.trim());
    if (parsed == null || parsed <= 0) return context.l10n.productsPriceInvalid;
    return null;
  }

  void onCategoryChanged(ProductCategory c) {
    if (iconNotifier.value != null && !(emojisByCategory[c]?.contains(iconNotifier.value) ?? false)) {
      iconNotifier.value = null;
      cubit.setIcon(null);
    }
    categoryNotifier.value = c;
  }
}
