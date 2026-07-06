package persistence;

public class BadFileFormatException extends Exception {
	private static final long serialVersionUID = 1L;
	private int lineNumber;
	
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
	
	public BadFileFormatException(int lineNumber) {
		this.lineNumber = lineNumber;
	}
	public BadFileFormatException(int lineNumber, String message) {
		super(message);
		this.lineNumber = lineNumber;
	}
	
	public int getExceptionLine() {return this.lineNumber;}
}