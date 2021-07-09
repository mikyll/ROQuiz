package persistenece;

public class BadFileFormatException extends Exception {
	private static final long serialVersionUID = 1L;

	public BadFileFormatException() {
	}

	public BadFileFormatException(String message) {
		super(message);
	}

	public BadFileFormatException(Throwable inner) {
		super(inner);
	}

	public BadFileFormatException(String message, Throwable inner) {
		super(message, inner);
	}

}