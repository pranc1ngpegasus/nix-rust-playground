pub fn hello(name: &'static str) -> String {
    return format!("Hello, {}!", name);
}

pub fn bye(name: &'static str) -> String {
    return format!("Goodbye, {}!", name);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        let greet = hello("pranc1ngpegasus");
        assert_eq!(greet, "Hello, pranc1ngpegasus!")
    }

    #[test]
    fn test_bye() {
        let greet = bye("pranc1ngpegasus");
        assert_eq!(greet, "Goodbye, pranc1ngpegasus!")
    }
}
