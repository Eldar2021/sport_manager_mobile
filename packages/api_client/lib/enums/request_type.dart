enum RequestType {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  download('DOWNLOAD'),
  patch('PATCH')
  ;

  const RequestType(this.value);
  final String value;
}
