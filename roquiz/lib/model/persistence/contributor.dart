// NB: fare poi lista di contributors ordinata per last update.
// Quando si fa il controllo:
// 0. Se alcuni utenti non sono più contributors, rimuoverli
// 1. Se ci sono utenti che non sono presenti localmente, dare priorità a quello (così risparmio chiamate alle API, visto che in futuro ""potremmo""" avere tanti contributors)
// 2. Ordinare gli utenti in base alla data di aggiornamento (prima quelli che non vengono controllati da tanto)
// 3. Per ciascuno, controllare se ci sono aggiornamenti (e.g. immagine profilo)

class Contributor {
  String username;
  String githubURL;
  DateTime lastChecked;
  String? encodedImage;

  Contributor({
    required this.username,
    required this.githubURL,
    required this.lastChecked,
    this.encodedImage,
  });
}
