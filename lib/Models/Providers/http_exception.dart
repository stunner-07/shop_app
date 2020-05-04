class HttpExecption implements Exception{
  final String messege;
  HttpExecption(this.messege);
  @override
  String toString() {
    
    return messege;
  }
}