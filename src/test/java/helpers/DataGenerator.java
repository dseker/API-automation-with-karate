package helpers;

import com.github.javafaker.Faker;
import net.minidev.json.JSONObject;

public class DataGenerator {
    public static String getRandomEmail() {
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 500) + "@gmail.com";
        return email;
    }

    public static String getRandomUsername() {
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static String getRandomTitle() {
        Faker faker = new Faker();
        String title = faker.book().title();
        return title;
    }

    public static JSONObject getRandomArticleValues() {
        Faker faker = new Faker();
        String title = faker.book().title();
        String description = faker.gameOfThrones().character();
        String body = faker.gameOfThrones().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;

    }
}
