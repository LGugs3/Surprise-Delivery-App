import

class prefPage extends homePage{
  class _FavoriteFoodsPageState extends State<FavoriteFoodsPage> {
    final _formKey = GlobalKey<FormState>();
    final List<String> _favoriteFoods = [];
    final TextEditingController _foodController = TextEditingController();

    Future<void> _savePreferences() async {
      if (_favoriteFoods.isNotEmpty) {
      await FirebaseFirestore.instance.collection('favoriteFoods').add({
      'foods': _favoriteFoods,
      'timestamp': FieldValue.serverTimestamp(),
      });

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Favorite foods saved!')),
    );

    _favoriteFoods.clear(); // Clear list after saving
    _foodController.clear();
    setState(() {}); // Update UI
    }
  }
}