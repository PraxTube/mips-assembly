fn plz(address: &str) -> usize {
    let mut current_plz = String::new();
    for c in address.chars() {
        if c.is_numeric() {
            current_plz.push(c);
        } else {
            current_plz = String::new();
        }

        if current_plz.len() == 5 {
            return current_plz.parse().unwrap();
        }
    }
    0
}

fn main() {
    println!("{}", plz("TU Berlin, 10623 Berlin"));
}

#[test]
fn check_plz() {
    let pairs = [
        ("TU Berlin, 10623 Berlin", 10623),
        ("Panoramastraße 1A in 1017 Berlin", 0),
        ("Die 4 Bremer (28195) Stadtmusikanten", 28195),
        ("78462 Konstanz Hauptbahnhof", 78462),
        ("1203790817", 12037),
        ("120 7908 7", 0),
    ];
    for i in 0..pairs.len() {
        assert_eq!(plz(pairs[i].0), pairs[i].1);
    }
}
