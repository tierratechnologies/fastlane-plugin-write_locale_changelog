describe Fastlane::Actions::WriteLocaleChangelogAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The write_locale_changelog plugin is working!")

      Fastlane::Actions::WriteLocaleChangelogAction.run(nil)
    end
  end
end
